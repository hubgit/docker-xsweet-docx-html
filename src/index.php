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
        'xsl/EXTRACT-docx.xsl',
        $tmp . '/input/word/document.xml',
        $outputFile
    ],
    'xsl/hyperlink-inferencer.xsl',
    'xsl/PROMOTE-lists.xsl',
    'xsl/header-promotion-CHOOSE.xsl',
    'xsl/final-rinse.xsl',
    'xsl/editoria-tune.xsl'
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
