import os

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

# tck_values = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]

# tck_values = [4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 5.0]

# tck_values = [4.00, 4.01, 4.02, 4.03, 4.04, 4.05, 4.06, 4.07, 4.08, 4.09, 4.10]

# Constant file that contains predefined values (CONST.v)
CONST_V_FILE = "CONST.v"
CONST_V_FILE_1 = "CONST_1.v"
CONST_V_FILE_2 = "CONST_2.v"

# Corner values
# corner_values = ["ss0p6v125c", "ss0p6v25c", "ss0p6vm40c", "ss0p72v125c", "ss0p72v25c", "ss0p72vm40c", 
#                  "tt0p6v125c", "tt0p6v25c", "tt0p6vm40c", "tt0p8v125c", "tt0p8v25c", "tt0p8vm40c", 
#                  "ff0p7v125c", "ff0p7v25c", "ff0p7vm40c", "ff0p88v125c", "ff0p88v25c", "ff0p88vm40c"]

corner_values = ["ff0p88vm40c", "tt0p8v25c", "ss0p72v125c", "ss0p6v125c"]

# corner_values = ["ff0p88vm40c", "ss0p6v125c"]

# 1. Create DEFINE.v file based on TCK value
def create_define_file(tck_value, corner_value):
    # Generate log filename based on TCK value and replace "." with "p"
    if (tck_value<10):
        tck_value_str = '000' + str(tck_value)
    elif (tck_value<100):
        tck_value_str = '00' + str(tck_value)
    elif (tck_value<1000):
        tck_value_str = '0' + str(tck_value)
    else:
        tck_value_str = str(tck_value)
    
    tck_value_str = tck_value_str.replace('.', 'p')

    log_filename = "./result/result_{0}_{1}.log".format(tck_value_str, corner_value)
    
    # Define content of DEFINE.v with TCK value and log filename
    define_content = """`define TCK {}
`define MYLOG "{}"
""".format(tck_value, log_filename)
    
    # Write the content to DEFINE.v file
    with open("DEFINE.v", "w") as define_file:
        define_file.write(define_content)
    
    print("DEFINE.v file created: TCK={}, MYLOG={}".format(tck_value, log_filename))

# 2. Create run script with the correct vcs command
def create_run_script(tck_value, corner_value):
    # Generate FSDB filename by replacing "." with "p"
    if (tck_value<10):
        tck_value_str = '000' + str(tck_value)
    elif (tck_value<100):
        tck_value_str = '00' + str(tck_value)
    elif (tck_value<1000):
        tck_value_str = '0' + str(tck_value)
    else:
        tck_value_str = str(tck_value)
    
    tck_value_str = tck_value_str.replace('.', 'p')

    fsdb_filename = "./result/result_{0}_{1}.fsdb".format(tck_value_str, corner_value)

    # Write the vcs command script for compilation and simulation
    vcs_command = """#!/bin/bash
set sim_v_file="/home/soc02/soc/report_2/syn/outputs/LFSR3B_{0}_{1}_gate.v"
set sim_sdf_file="/home/soc02/soc/report_2/syn/outputs/LFSR3B_{0}_{1}_gate.sdf"

vcs -full64 \\
-debug_acc+all \\
+v2k -sverilog \\
+sdfverbose \\
+lint=all,noVCDE \\
-notice \\
-line \\
-timescale=1ns/1ps \\
-l ./logs/compile.log \\
-o simv \\
-f ./list.f \\
$sim_v_file \\
+vcs+dumpvars+{2} \\
-t TB_LFST3B +neg_tchk\\
-sdf_cmd_file=$sim_sdf_file \\
-P ${{VERDI_HOME}}/share/PLI/VCS/LINUX64/novas.tab \\
${{VERDI_HOME}}/share/PLI/VCS/LINUX64/pli.a
""".format(tck_value_str, corner_value, fsdb_filename)

    # Write the command to a run script
    with open("run", "w") as run_file:
        run_file.write(vcs_command)
    
    # Make the run script executable
    os.chmod("run", 0755)  # Python 2 uses octal literals without '0o'
    print("run script created: FSDB filename={}".format(fsdb_filename))


# 3. Create TB_LFSR3B.v by combining CONST.v and DEFINE.v
def create_tb_lfsr3b(tck_value, corner_value):
    if (tck_value<10):
        tck_value_str = '000' + str(tck_value)
    elif (tck_value<100):
        tck_value_str = '00' + str(tck_value)
    elif (tck_value<1000):
        tck_value_str = '0' + str(tck_value)
    else:
        tck_value_str = str(tck_value)
    
    tck_value_str = tck_value_str.replace('.', 'p')

    annotate_content = """
    initial begin
        $sdf_annotate("./../syn/outputs/LFSR3B_{0}_{1}_gate.sdf", DUT);
    end
""".format(tck_value_str, corner_value)
    
    # Open the TB_LFSR3B.v file for writing
    with open("TB_LFSR3B.v", "w") as output_tb_file:
        # Append the contents of CONST.v to TB_LFSR3B.v
        with open("DEFINE.v", "r") as define_file:
            output_tb_file.write(define_file.read())
        
        # # Append the contents of DEFINE.v to TB_LFSR3B.v
        # with open(CONST_V_FILE_1, "r") as const_v1_file:
        #     output_tb_file.write(const_v1_file.read())

        # output_tb_file.write(annotate_content)

        # with open(CONST_V_FILE_2, "r") as const_v2_file:
        #     output_tb_file.write(const_v2_file.read())
        with open(CONST_V_FILE, "r") as const_v_file:
            output_tb_file.write(const_v_file.read())

    print("TB_LFSR3B.v file created.")
    
    # Execute the run script to run vcs commands
    os.system("./run")
    os.system("./simv")

# Loop through TCK values and conners
for corner_value in corner_values:
    for tck in tck_values:
        create_define_file(tck, corner_value)  # Create DEFINE.v file
        create_run_script(tck, corner_value)   # Create run script with vcs command
        create_tb_lfsr3b(tck, corner_value)   # Create TB_LFSR3B.v and execute run script
