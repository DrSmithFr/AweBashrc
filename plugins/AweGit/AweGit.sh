function help() {
cat <<EOF
usage : git [--version] [--help] [-C <path>] [-c name=value]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

Les commandes git les plus utilisées sont :
   add        Ajouter le contenu de fichiers dans l'index
   bisect     Trouver par recherche binaire la modification qui a introduit un bogue
   branch     Lister, créer ou supprimer des branches
   checkout   Extraire une branche ou des chemins dans la copie de travail
   clone      Cloner un dépôt dans un nouveau répertoire
   commit     Enregistrer les modifications dans le dépôt
   diff       Afficher les changements entre les validations, entre validation et copie de travail, etc
   fetch      Télécharger les objets et références depuis un autre dépôt
   grep       Afficher les lignes correspondant à un motif
   init       Créer un dépôt Git vide ou réinitialiser un existant
   log        Afficher l'historique des validations
   merge      Fusionner deux ou plusieurs historiques de développement ensemble
   mv         Déplacer ou renommer un fichier, un répertoire, ou un lien symbolique
   pull       Rapatrier et intégrer un autre dépôt ou une branche locale
   push       Mettre à jour les références distantes ainsi que les objets associés
   rebase     Reporter les validations locales sur le sommet mis à jour d'une branche amont
   reset      Réinitialiser la HEAD courante à l'état spécifié
   rm         Supprimer des fichiers de la copie de travail et de l'index
   show       Afficher différents types d'objets
   status     Afficher le statut de la copie de travail
   tag        Créer, lister, supprimer ou vérifier un objet d'étiquette signé avec GPG
   search     List les branches distante qui contienne le texte passer en paramètre
   master     Command: git checkout master && git fetch && git pull
   up         Command: git push -u origin [this branch]

'git help -a' et 'git help -g' listent les sous-commandes disponibles et
quelques concepts. Voir 'git help <command>' ou 'git help <concept>'
pour en lire plus à propos d'une commande spécifique ou d'un concept.
EOF
}

function git_file_diff_lg()
{
    if [ $# = 0 ]; then
        git_file_diff $(git log --pretty=oneline --abbrev-commit)
    else
        if [ $# = 1 ]; then
            if [[ $1 == -* ]]; then
                git_file_diff $(git log --pretty=oneline --abbrev-commit $1 | cut -d' ' -f1)
            else
                git_file_diff $1
            fi
        else
            git_file_diff $@
        fi
    fi
}

function git_file_diff()
{
    for hash in $@
    do
        git lg -1 "$hash"
        for file in $(git diff-tree --no-commit-id --name-only -r $hash)
        do
            echo -e "\t- $file";
        done
        echo ""
    done
}

function git_get_repo_log_file() {
    repo_name=$(git config --get remote.origin.url | awk -F ":" '{print $2}'| tr / _).log

    if [[ ! -d "$AWE_EXT_AWEGIT_LOG_DIR" ]]
    then
        mkdir -p "$AWE_EXT_AWEGIT_LOG_DIR" &> /dev/null
    fi

    log_file="$AWE_EXT_AWEGIT_LOG_DIR/$repo_name"

    if [[ ! -f "$log_file" ]]
    then
        touch "$log_file" &> /dev/null
    fi

    echo "$log_file"
}

function git_log_branch_clear() {
    log_file=$(git_get_repo_log_file)
    rm -f "$log_file"
    git_log_branch_history
}

function git_log_branch_history()
{
    currentDate=$(date +"%Y-%m-%d")
    currentTime=$(date +"%T")

    branch_name=$(git symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-HEAD}

    log_file=$(git_get_repo_log_file)

    last_date=$(tail -n1 <$log_file | cut -f1)
    last_branch_name=$(tail -n1 <$log_file | cut -f3)

    if [[ "$last_date" != "$currentDate" || "$branch_name" != "$last_branch_name" ]]
    then
        echo -e "${currentDate}\t${currentTime}\t${branch_name}" >> "$log_file"
    fi
}

function git_read_branch_history()
{
    echo -e "History of branch changes for $(git config --get remote.origin.url | awk -F ":" '{print $2}')"
    while read line
    do
        branchDate=$(echo "$line"|cut -f1)
        branchTime=$(echo "$line"|cut -f2)
        branch_name=$(echo "$line"|cut -f3)
        spendTime=$(($(date "+%s") - $(date -d "$branchDate $branchTime" "+%s")))
        showTime=$(displaytime spendTime)

        printf " - %-40s %s\n" "$branch_name" "$showTime ago"
    done < "$(git_get_repo_log_file)"
}

function git_time_on_branch_history()
{
    echo -e "History of time spendTime by branch for $(git config --get remote.origin.url | awk -F ":" '{print $2}')"
    count=0
    while read line
    do
        branchDate=$(echo "$line"|cut -f1)
        branchTime=$(echo "$line"|cut -f2)
        branch_name=$(echo "$line"|cut -f3)

        if [[ $count -ne 0 ]]
        then
            spendTime=$(($(date -d "$branchDate $branchTime" "+%s") - $(date -d "$lastBranchDate $lastBranchTime" "+%s")))
            showTime=$(displaytime spendTime)

            printf " - %-40s %s\n" "$lastBranchName" "$showTime"
        fi

        lastBranchDate=$branchDate
        lastBranchTime=$branchTime
        lastBranchName=$branch_name

        ((count++))
    done < "$(git_get_repo_log_file)"

    spendTime=$(($(date "+%s") - $(date -d "$branchDate $branchTime" "+%s")))
    showTime=$(displaytime spendTime)

    printf " - %-40s %s\n" "$branch_name" "$showTime"
}

function displaytime {
    local T=$1

    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))

    [[ $D > 0 ]] && echo "~ $D days" && exit 0
    [[ $H > 0 ]] && echo "~ $H hours" && exit 0
    [[ $M > 0 ]] && echo "~ $M minutes" && exit 0
    echo "$S seconds" && exit 0
}

##############################################################
########################### USAGE ############################
##############################################################
opt=$1
shift

case $opt in
    diff)
        command git diff $@
    ;;
    master)     command git checkout master && git fetch && git pull          ;;
    search)     command git branch -r | grep --color=auto $@                  ;;
    lgdiff)     git_file_diff_lg $@                                           ;;
    up)         command git push -u origin $(git rev-parse --abbrev-ref HEAD) ;;
    ci)         command git commit "$@"                                       ;;
    commit)     command git commit "$@"                                       ;;
    branch)
        opt=$1
        shift
        case $opt in
            -h|--history)               git_read_branch_history    ;;
            -t|--time-history)          git_time_on_branch_history ;;
            -l|--log)                   git_log_branch_history     ;;
            -c|--clear)                 git_log_branch_clear       ;;
            *)                          command git branch $opt    ;;
        esac
        ;;
    checkout|co)
        opt=$1
        shift
        case $opt in
            -b)   command git checkout -b $@ && git push -u origin $(git rev-parse --abbrev-ref HEAD) --no-verify ;;
            ".")  command git checkout . ; git_log_branch_history                                                 ;;
            "-")  command git checkout - ; git_log_branch_history                                                 ;;
            -h|--history)               git_read_branch_history                                                   ;;
            -t|--time-history)          git_time_on_branch_history                                                ;;
            -l|--log)                   git_log_branch_history                                                    ;;
            -c|--clear)                 git_log_branch_clear                                                      ;;
            *)
                if [ -f "$opt" ]
                then
                    command git checkout $opt
                    git_log_branch_history
                else
                    nbBranch=$(git branch -r | grep --color=auto $opt | cut -d'/' -f2 | wc -l)
                    if [ "1" == "$nbBranch" ]
                    then
                        branch=$(git branch -r | grep --color=auto $opt | cut -d'/' -f2)
                        command git checkout $branch && git pull
                        git_log_branch_history
                    else
                        isExact=false;
                        for b in $(git branch -r | grep --color=auto $opt | cut -d'/' -f2)
                        do
                            if [ "$b" == "$opt" ]
                            then
                                isExact=true;
                            fi
                        done
                    
                        if [ $isExact == true ]
                        then
                            command git checkout $opt && git pull
                            git_log_branch_history
                        else
                            echo "ERROR: 'git checkout $opt' impossible ! Il y a $nbBranch branches qui contienne '$opt'"
                            command git branch -r | grep $opt | cut -d'/' -f2 | grep --color=auto $opt
                        fi
                    fi
                fi
            ;;
        esac
    ;;
    help)       help                                                  ;;
    stash)
        opt=$1
        shift
        case $opt in
            pop|load|drop|show|apply)
                    nbStash=$(git stash list | grep --color=auto $@ | cut -d':' -f1 | wc -l)
                    if [ "1" == "$nbStash" ]
                    then
                        stash=$(git stash list | grep --color=auto $@ | cut -d':' -f1)
                        command git stash $opt $stash
                    else
                        echo "ERROR: 'git stash $opt $@' impossible ! Il y a $nbStash stash qui contienne '$@':"
                        command git stash list | grep $@
                    fi
                ;;
            search) command git stash list | grep --color=auto $@;;
            save)   command git stash save $@                    ;;
            clear)  command git stash clear $@                   ;;
            *)      command git stash list $@                    ;;
        esac
    ;;
    pull)       command git fetch && git pull                         ;;
    *)          command git ${opt} $@                                 ;;
esac

