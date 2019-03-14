This is the README file.

To use pipeline:

--

Download by:

$ git clone https://github.com/ozankiratli/DNA-Alignment-Pipeline.git

--

Make a subdirectory named data and put raw fastq files there:

$ mkdir Data

$ cp /path/to/data/* Data/

--

- Put the path to reference into PARAMETERS file and check the parameters
- Carefully change the PARAMETERS, DIRECTORIES, and PROGRAMPATHS.


--

Run the scripts with

$ ./runall.sh 

--

If you encounter any errors during the process and clean all the files created by the script:

$ ./resetanalysis.sh
