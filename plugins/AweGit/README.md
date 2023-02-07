AweBash Plugin AweGit
=====================
 
Plugin Alias
------------

- `gti` : Execute `git` (avoid mistyping)
- `gto` : Execute `git` (avoid mistyping)
- `got` : Execute `git` (avoid mistyping)

- `gs`  : Execute `git status`
- `gc`  : Execute `git commit`
- `ga`  : Execute `git add`
- `gd`  : Execute `git diff`
- `gb`  : Execute `git branch`
- `gl`  : Execute `git log`
- `gsb` : Execute `git show-branch`
- `gco` : Execute `git checkout`
- `gg`  : Execute `git grep`
- `gk`  : Execute `gitk --all`
- `gr`  : Execute `git rebase`
- `gri` : Execute `git rebase --interactive`
- `gcp` : Execute `git cherry-pick`
- `grm` : Execute `git rm`

Plugin content
--------------
Show git contribution for the current user.
- `git_contrib` : Show git contribution for all user for repository
- `git_contrib_since 2020-12-30` : Show git contribution for all user for repository since given date

Adding a git history of branches to ease time tracking.
- `git branch|checkout -h|--history` : Show git history of branches switch (compare with current time/date)
- `git branch|checkout -t|--time-history` : Show git history of branches switch (compare with previous switch)
- `git branch|checkout -c|--clear` : Clear git history of branches switch
- `git branch|checkout -l|--log` : Log the current branch to the switch log files (Automatically called by `git checkout` or  `cd in_git_folder`) )