<?php

if (php_sapi_name() !== 'cli') {
    exit('The update script must be run from the command line');
}

$urls = [
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/docx-extract/collapse-paragraphs.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/docx-extract/docx-html-extract.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/docx-extract/handle-notes.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/docx-extract/join-elements.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/docx-extract/scrub.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/html-polish/final-rinse.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/list-promote/itemize-lists.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/list-promote/mark-lists.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/header-promote/make-header-escalator-xslt.xsl',
    'https://gitlab.coko.foundation/XSweet/XSweet/raw/ink-api-publish/applications/header-promote/digest-paragraphs.xsl',
    'https://gitlab.coko.foundation/XSweet/editoria_typescript/raw/ink-api-publish/p-split-around-br.xsl',
    'https://gitlab.coko.foundation/XSweet/editoria_typescript/raw/ink-api-publish/editoria-notes.xsl',
    'https://gitlab.coko.foundation/XSweet/editoria_typescript/raw/ink-api-publish/editoria-basic.xsl',
    'https://gitlab.coko.foundation/XSweet/editoria_typescript/raw/ink-api-publish/editoria-reduce.xsl',
];

$outputDir = '/var/www/html/xsl';

if (!file_exists($outputDir)) {
    mkdir($outputDir);
}

foreach ($urls as $url) {
    $input = fopen($url, 'r');
    if (!$input) {
        exit("Failed opening $url\n");
    }

    $outputPath = $outputDir . '/' . basename($url);
    $output = fopen($outputPath, 'w');
    if (!$output) {
        exit("Failed opening $outputPath\n");
    }

    print("Copying $url to $outputPath\n");
    $result = stream_copy_to_stream($input, $output);
    if (!$result) {
        exit("Failed copying $url to $outputPath\n");
    }

    fclose($input);
    fclose($output);
}
