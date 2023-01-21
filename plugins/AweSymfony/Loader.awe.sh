# Symfony
alias console="symfony console"

#alias composer="symfony composer"
#Removing politics from the composer.
alias composer="2> >(grep -av 'StandWith') symfony composer --ansi "

alias php="symfony php"
alias phpunit="symfony php bin/phpunit"
alias phpunit-coverage="symfony php bin/phpunit --coverage-html coverage"
