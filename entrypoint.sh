#!/bin/bash
set -e

php update.php

docker-php-entrypoint apache2-foreground
