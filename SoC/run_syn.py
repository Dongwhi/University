import os
import sys
import subprocess

# dc_shell command to Python script
def run_dc_shell_with_tcl(tcl_script):
    # dc_shell command
    dc_shell_command = "dc_shell -x \"source {}; quit;\"".format(tcl_script)
    
    try:
        # start
        process = subprocess.Popen(
            dc_shell_command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
            
        # print result
        stdout, stderr = process.communicate()
        sys.stdout.write(stdout)
        sys.stderr.write(stderr)
        #print("STDOUT:\n", stdout)
        #print("STDERR:\n", stderr)

        # fail check
        if process.returncode != 0:
            print("dc_shell Fail:", process.returncode)
        else:
            print("dc_shell Success!")
    except OSError as e:
        print("OSError:", e)
    except Exception as e:
        print("ExError:", e)

tcl_script_path = "run.tcl"

# TCK values from 0.1ns to 1000ns with an interval of 10% for each log scale
#tck_values = []
#tck_values.extend([0.1 + 0.1 * i for i in range(9)])  # 0.1, 0.2, ..., 0.9
#tck_values.extend([1.0 + 1.0 * i for i in range(9)])  # 1.0, 2.0, ..., 9.0
#tck_values.extend([10.0 + 10.0 * i for i in range(9)])  # 10.0, 20.0, ..., 90.0
#tck_values.extend([100.0 + 100.0 * i for i in range(10)])  # 100.0, 200.0, ..., 1000.0

tck_values = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 
               1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 
               10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 
               100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0]

#tck_values = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]

#tck_values = [4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 5.0]

# tck_values = [4.00, 4.01, 4.02, 4.03, 4.04, 4.05, 4.06, 4.07, 4.08, 4.09, 4.10]

# Constant file that contains predefined values (CONST.setup, CONST.sdc)
CONST_SETUP_FILE = "CONST.setup"
CONST_SDC_FILE = "CONST.sdc"

TOPDESIGN_str = "TOPDESIGN"

# Corner values
# corner_values = ["ss0p6v125c", "ss0p6v25c", "ss0p6vm40c", "ss0p72v125c", "ss0p72v25c", "ss0p72vm40c", 
#                  "tt0p6v125c", "tt0p6v25c", "tt0p6vm40c", "tt0p8v125c", "tt0p8v25c", "tt0p8vm40c", 
#                  "ff0p7v125c", "ff0p7v25c", "ff0p7vm40c", "ff0p88v125c", "ff0p88v25c", "ff0p88vm40c"]
# io_voltage = ["0", "0", "0", "1p62v", "1p62v", "1p62v", 
#               "0", "0", "0", "1p8v", "1p8v", "1p8v", 
#               "0", "0", "0", "1p96v", "1p96v", "1p96v"]


corner_values = ["ff0p88vm40c", "tt0p8v25c", "ss0p72v125c", "ss0p6v125c"]
io_voltage = ["0", "0", "0", "0"]

# corner_values = ["ff0p88vm40c", "ss0p6v125c"]
# io_voltage = ["0", "0"]

# 4. Create corner.setup file
def create_temp_setup(corner_value, io_voltage):
    # set content of temp.setup with corner values
    if (io_voltage != "0"):
        set_content = """set target_library "saed14rvt_{0}.db"
set link_library "* $target_library \\
saed14io_fc_{0}_{1}.db \\
saed14pll_{0}.db \\
saed14sram_{0}.db \\
dw_foundation.sldb"
""".format(corner_value, io_voltage)
    else:
        set_content = """set target_library "saed14rvt_{0}.db"
set link_library "* $target_library \\
dw_foundation.sldb"
""".format(corner_value)
    # Write the content to DEFINE.v file
    with open("temp.setup", "w") as corner_file:
        corner_file.write(set_content)
    
    print("temp.setup file created: at {}".format(corner_value))


# 5. Create my_corner.setup file based on Corner by combining CONST.setup and corner.setup
def create_setup():
    # Open my_corner.setup file for writing
    with open("my_corner.setup", "w") as my_corner_file:
        with open(CONST_SETUP_FILE, "r") as const_setup_file:
            my_corner_file.write(const_setup_file.read())
        with open("temp.setup", "r") as corner_file:
            my_corner_file.write(corner_file.read())
    print("my_corner.setup file created")

# 6. Create time constraint file
def create_temp_sdc(tck_value):
    constraint_content = """create_clock -name "CLOCK" -period {0} -waveform {{0 {1}}} [get_ports CLK]
set_clock_latency {2} [get_clock CLOCK]
set_clock_uncertainty -setup {2} [get_clock CLOCK]
set_clock_uncertainty -hold {3} [get_clock CLOCK]
set_clock_transition {3} [get_clock CLOCK]
""".format(tck_value, tck_value/2, tck_value*0.1, tck_value*0.05)

#     constraint_content = """create_clock -name "CLOCK" -period {0} -waveform {{0 {1}}} [get_ports CLK]
# set_clock_latency 0.1 [get_clock CLOCK]
# set_clock_uncertainty -setup 0.1 [get_clock CLOCK]
# set_clock_uncertainty -hold 0.05 [get_clock CLOCK]
# set_clock_transition 0.05 [get_clock CLOCK]
# """.format(tck_value, tck_value/2, tck_value*0.1, tck_value*0.05)
    
    with open("temp.sdc", "w") as constraint_file:
        constraint_file.write(constraint_content)
    print("temp.sdc file created: at {}".format(tck_value))


# 7. Create LFSR3B.sdc file
def create_sdc():
    # Open LFSR3B.sdc file for writing
    with open("./sdc/LFSR3B.sdc", "w") as sdc_file:
        with open("temp.sdc", "r") as constraint_file:
            sdc_file.write(constraint_file.read())
        with open(CONST_SDC_FILE, "r") as const_sdc_file:
            sdc_file.write(const_sdc_file.read())
    print("LFSR3B.sdc file created.")


     
# 8. Create .tcl file
def create_tcl(tck_value, corner_value):
    if (tck_value<10):
        tck_value_str = '000' + str(tck_value)
    elif (tck_value<100):
        tck_value_str = '00' + str(tck_value)
    elif (tck_value<1000):
        tck_value_str = '0' + str(tck_value)
    else:
        tck_value_str = str(tck_value)
    
    tck_value_str = tck_value_str.replace('.', 'p')
    # Write the run.tcl
    tcl_content = """source my_corner.setup
set TOPDESIGN LFSR3B
set RTL_FILES {{/home/soc02/soc/report_2/rtl/LFSR3B.v}}
read_file -format verilog $RTL_FILES
current_design $TOPDESIGN
analyze -format verilog $RTL_FILES
elaborate ${{TOPDESIGN}}
link
check_design
source ./sdc/${{TOPDESIGN}}.sdc -verbose
check_timing
write_file -format ddc -output ./outputs/${{TOPDESIGN}}_{0}_{1}_unmapped.ddc
compile_ultra -no_autoungroup
report_constraint -all_violators
report_clock
report_timing
write_file -format verilog -output ./outputs/${{TOPDESIGN}}_{0}_{1}_gate.v
write_file -format ddc -output ./outputs/${{TOPDESIGN}}_{0}_{1}_gate.ddc
write_sdf ./outputs/${{TOPDESIGN}}_{0}_{1}_gate.sdf
""".format(tck_value_str, corner_value)
    # Write the command to a run script
    with open("run.tcl", "w") as tcl_file:
        tcl_file.write(tcl_content)
    
    # Make the run script executable
    os.chmod("run.tcl", 0755)  # Python 2 uses octal literals without '0o'
    print("run.tcl script created")



for i in range(len(corner_values)):
    for tck in tck_values:
        print("============ corner: {0}, clock period: {1} ==============".format(corner_values[i], tck))
        create_temp_setup(corner_values[i], io_voltage[i])
        create_setup()
        create_temp_sdc(tck)
        create_sdc()
        create_tcl(tck, corner_values[i])
        run_dc_shell_with_tcl(tcl_script_path)
