# Symfony
if ! command -v symfony &> /dev/null
then
    alias console="php console"

    #alias composer="symfony composer"
    #Removing politics from the composer.
    alias composer="2> >(grep -av 'StandWith') composer --ansi "

    alias phpunit="php bin/phpunit"
    alias phpunit-coverage="php bin/phpunit --coverage-html coverage"
else
  alias console="symfony console"

  #alias composer="symfony composer"
  #Removing politics from the composer.
  alias composer="2> >(grep -av 'StandWith') symfony composer --ansi "

  alias php="symfony php"
  alias phpunit="symfony php bin/phpunit"
  alias phpunit-coverage="symfony php bin/phpunit --coverage-html coverage"
fi