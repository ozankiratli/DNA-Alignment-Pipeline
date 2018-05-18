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

Run the scripts:

$ ./runall.sh /path/to/reference

--

If you encounter any errors during the process and clean all the files created by the script:

$ ./resetanalysis.sh
