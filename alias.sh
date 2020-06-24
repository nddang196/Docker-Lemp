#!/bin/bash
printf "
#
## Docker compose alias
#
alias doco=\"docker-compose\"
alias redis=\"docker-compose exec redis\"
alias elasticsearch=\"docker-compose exec elasticsearch\"
alias m2=\"docker-compose exec -u www php m2\"
alias magento=\"docker-compose exec -u www php bin/magento\"
alias art=\"docker-compose exec -u www php php artisan\"
alias php=\"docker-compose exec -u www php php\"
alias composer=\"doco exec -u www php composer\"
" >> ~/.zshrc