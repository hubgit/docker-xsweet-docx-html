<?php

$saxonProcessor = new Saxon\SaxonProcessor();
// print "Saxon processor version: {$saxon->version()}\n";

$xsltProcessor = $saxonProcessor->newXsltProcessor();

$tmp = tempnam(sys_get_temp_dir(),'xsweet');
unlink($tmp);
mkdir($tmp);
mkdir($tmp . '/input');

$outputFile = tempnam(sys_get_temp_dir(), 'xsweet');

$zip = new ZipArchive;
$zip->open($_FILES['input']['tmp_name']);
$zip->extractTo($tmp . '/input');

$steps = [
    [
        'xsl/docx-html-extract.xsl',
        $tmp . '/input/word/document.xml',
        $outputFile
    ],
    'xsl/handle-notes.xsl',
    'xsl/join-elements.xsl',
    'xsl/scrub.xsl',
    'xsl/collapse-paragraphs.xsl',
    [
        'xsl/digest-paragraphs.xsl',
        $outputFile,
        $tmp . '/paragraphs.xml'
    ],
    [
        'xsl/make-header-escalator-xslt.xsl',
        $tmp . '/paragraphs.xml',
        $tmp . '/header-escalator.xsl'
    ],
    $tmp . '/header-escalator.xsl',
    'xsl/final-rinse.xsl',
    'xsl/p-split-around-br.xsl',
    'xsl/editoria-notes.xsl',
    'xsl/editoria-basic.xsl',
    'xsl/editoria-reduce.xsl'
];

foreach ($steps as $step) {
    if (!is_array($step)) {
        $step = [$step, $outputFile, $outputFile];
    }

    list($xsl, $input, $output) = $step;

    $xsltProcessor->compileFromFile($xsl);
    $xsltProcessor->setSourceFromFile($input);
    $xsltProcessor->setOutputFile($output);
    $xsltProcessor->transformToFile();
    $xsltProcessor->clearParameters();
    $xsltProcessor->clearProperties();
}

readfile($outputFile);
unlink($outputFile);
// TODO: unlink $tmp recursively
