## basic `git` commands

```bash
git diff --word-diff
```

Often a more informative, nicer `git diff`. Instead of showing _lines_ where things where added/deleted, it focuses on the individual words instead

```bash
git commit -a -m "commit message"
```

Skip staging and commit all changes to tracked files.

To have `git` untrack a file (i.e. retain a file on your hard drive but have `git` stop tracking it), use

```bash
git rm --cached file_name # to remove file_name from tracking
git rm log/\*.log # to remove all .log files
```

You can see the diff within a call to `git log` like

```bash
git log -p
```

`git log` has a lot of nice options, e.g.:

```bash
git log --oneline
git log --graph
```



If you commit too early, you can use 

```bash
git commit --amend
```

to add more files to your previous commit. The workflow looks something like

- commit
- add forgotten files to staging area
- `git commit --amend`



Using `git remote show` can be useful when you're using `git` with Github or GitLabs.



Tagging is often pretty convenient. Git has _annotated_ tags and _lightweight_ tags. It usually makes sense to use _annotated_ tags. Lightweight tags are just pointers to specific commits; annotated tags are checked summed and are their own commit. 

Create an annotated tag like 

```bash
git tag -a v0.0.1 -m 'my version 0.0.1'
```

List your tags with `git tag`.

Create a lightweight tag with `git tag v0.0.1`.

You can also tag after the fact:

```bash
git tag -a v1.2 -m "version 1.2" 5lhdf4
```

where `5lhdf4` is that hash for the commit you want to tag.

Importantly, tags are shared with remote repos unless you push them:

```bash
git push origin v1.2
```

Git also allows you to configure aliases for common commands easily:

```bash
git config --global alias.ci commit # to commit with `git ci`
git config --global alias.test 'log -1 HEAD' # to see your last commit easily
git config --global alias.unstage 'reset HEAD --' # to unstage a file from the staging area
```

#### reminder:

`git diff` compares what is in your working directory with what's in your staging area. It gives you the changes you've made but haven't yet staged. If you want to compare what you've staged and will go into the next commit, use `git diff --cached` or `git diff --staged`.

`HEAD` is just a pointer to the branch you're on.

## branches

Create a new branch: `git branch branch_name`.

Switch to a branch: `git checkout branch_name`

View branches: `git branch`

Merge branches: `git checkout master && git merge branch_name`

Delete a branch: `git branch -d branch_name`

Get the last commit in each branch: `git branch -v`

To see the branches that are already merged into the branch you're on: `git brach --merged`

To see branches that contain work that hasn't been merged: `git branch --no-merged`



__Rebasing__ is a convenient alternative to merging. Rebasing 'replays' your series of commits on top on a branch instead of merging. It makes your commit history look linear instead of parallel, which is was, providing for a cleaner history. 

To rebase:  

` git checkout master_branch` 

`git rebase master_branch topic_branch` 

`git checkout master_branch` 

`git merge topic_branch`

 `git branch -d topic_branch`

__Do not rebase commits that have already been pushed to a public repo that people might have pulled down.__

