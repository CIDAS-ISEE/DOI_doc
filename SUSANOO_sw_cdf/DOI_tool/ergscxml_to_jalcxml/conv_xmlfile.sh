##!/bin/bash
#!/bin/sh
#
# Usage:
#    conv_xmlfile.sh ../hep/erg_hep_l2_3dflux_ergsc.xml
#
# This script can run anywhere now, by typing the absolute paths of this script and 
# an xml file as the argument.
#
#  The above command, for examples, will convert ../hep/erg_hep_l2_3dflux_ergsc.xml to
#  an xml file that is used for DOI registraion as
#  ../hep/output/xml/forjalc_erg_hep_l2_3dflux_ergsc.xml, and a landing page html file as 
#  ../hep/output/html/DATA_ERG-00001.html.
#
#  You need to have a Java compiler and jar files for the saxon9he libraries
#  properly installed to the designated directories on your pc, which should be given
#  with variables JAVA and JAVACLASSPATH. 
#
#  Contact:
#    Tomo Hori, CIDAS, ISEE, Nagoya Univ.
#
#  Credit:
#    The original version of the script and xslt files were developed and 
#    provided by C-SODA, ISAS, JAXA. 
#



JAVA=/usr/bin/java
JAVACLASSPATH=~/SaxonHE12-5J
SAXON=${JAVACLASSPATH}/saxon-he-12.5.jar
# JAVA=/usr/bin/java
# JAVACLASSPATH=/usr/local/lib/java/classes
# SAXON=${JAVACLASSPATH}/saxon9he.jar


OUTPUT_dir=output
XML_outdir=${OUTPUT_dir}/xml
HTML_outdir=${OUTPUT_dir}/html

# Clean up the local output dir.
##/bin/rm -rf ./${OUTPUT_dir} >/dev/null 2>&1

# Obtain the directory path in which this script (conv_xmlfile.sh) is located.
SCRIPT_DIR=$(cd $(dirname $0); pwd)


for orgxml in $*;
do

    # Check if the original xml file exists
    if [ ! -f "${orgxml}" ]; then
       continue
    fi

    # Create the local output directories
    mkdir -p ./${XML_outdir} ./${HTML_outdir} >/dev/null 2>&1
    orgxmldir=$(dirname ${orgxml})
    mkdir -p ${orgxmldir}/${XML_outdir} ${orgxmldir}/${HTML_outdir} >/dev/null 2>&1

    # Target xml file
    jalcxml=${orgxmldir}/${XML_outdir}/forjalc_$(basename ${orgxml})
    echo ${orgxml} "--->" ${jalcxml} and a landing page...
    
    make -f - <<EOF
    
${jalcxml}: ${orgxml}
	    ${JAVA} -jar ${SAXON} ${orgxml} ${SCRIPT_DIR}/xslt/to_JaLCxml/to_JaLC.xsl  >${jalcxml}
	    ${JAVA} -jar ${SAXON} ${orgxml} ${SCRIPT_DIR}/xslt/to_html/html.xsl
	    rsync -au ./${OUTPUT_dir}/ ${orgxmldir}/${OUTPUT_dir}/

EOF

done

# Remove the local output dir.
echo $(pwd)
echo ${orgxmldir}
if [ "$(pwd)" = "${orgxmldir}" ]; then 
  /bin/rm -rf ./${OUTPUT_dir} >/dev/null 2>&1
fi



