#!/bin/bash
printf "
alias redis=\"docker-compose exec redis\"
alias elasticsearch=\"docker-compose exec elasticsearch\"
alias n98=\"docker-compose exec -u www php mgt\"
alias magento=\"docker-compose exec -u www php bin/magento\"
alias artisan=\"docker-compose exec -u www php php artisan\"
alias php=\"docker-compose exec -u www php php\"
alias composer=\"doco exec -u www php composer\"
" >> ~/.zshrc