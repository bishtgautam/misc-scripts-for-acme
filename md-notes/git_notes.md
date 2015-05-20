<!---
![ACME logo](logos/ACME_Logo.png =250x)
<img src="logos/ACME_Logo.png" alt="ACME logo" style="width: 250px;"/>
-->

**Author: Gautam Bisht** (<gbisht@lbl.gov>)

---

[TOC]

# Git commands


## Clone
```
git clone git@github.com:ACME-Climate/ACME.git
```


## View log

```
> git log --pretty=format:"%h: %s" -15 --graph
*   cab58cf: Merge branch 'jgfouca/scripts/edison_machine_file_use_acme' (PR #171)
|\  
| * 9c93d68: Change edison config to use acme project area for baselines and input
|/  
*   bd30e82: Merge branch 'jgfouca/scripts/setup_edison_on_jenkins' (PR #170)
|\  
| * ac44a2f: Make necessary changes to jenkins python scripts to support edison
|/  
*   c66c8aa: Merge branch 'jgfouca/scripts/jenkins_dont_wait_if_nlonly' (PR #169)
|\  
| * 0a002cf: jenkins_generic_job: Don't process test results or wait_for_tests if --namelists-only
|/  
*   990a063: Merge branch 'jgfouca/scripts/compare_namelists_bugfix' (PR #166)
|\  
| * 7c2c399: compare_namelists: Fix bug in error message generation
|/  
*   f8c16ce: Merge pull request #153 from ACME-Climate/ACME/daliwang/land/icase
|\  
| * f768556: Add Smoke Test of I1850CLM45CN into acme_developer_test
* |   32c529c: Merge branch 'singhbalwinder/atm/add-demott-ice-nucleation'
|\ \  
| * | c9771b7: dcs and seasalt emission factor in namelist
| * | 5b6d92b: Modified abortuils to cam_abortutils in three files
| * | f4e1784: ADD DEMOTT ICE NUCLEATION SCHEME AND BUG FIXES
| * | c64a6b0: Improve aerosol scavenging and resuspension [HD mods]

```

## View incoming commits

```
# show commits that are on upstream stream remote branch but are absent in local HEAD
> git log HEAD..@{u} --pretty=format:"%h: %s"
cab58cf: Merge branch 'jgfouca/scripts/edison_machine_file_use_acme' (PR #171)
9c93d68: Change edison config to use acme project area for baselines and input
bd30e82: Merge branch 'jgfouca/scripts/setup_edison_on_jenkins' (PR #170)
ac44a2f: Make necessary changes to jenkins python scripts to support edison
c66c8aa: Merge branch 'jgfouca/scripts/jenkins_dont_wait_if_nlonly' (PR #169)
0a002cf: jenkins_generic_job: Don't process test results or wait_for_tests if --namelists-only
990a063: Merge branch 'jgfouca/scripts/compare_namelists_bugfix' (PR #166)
7c2c399: compare_namelists: Fix bug in error message generation
f8c16ce: Merge pull request #153 from ACME-Climate/ACME/daliwang/land/icase
32c529c: Merge branch 'singhbalwinder/atm/add-demott-ice-nucleation'
...
```


## Pull
```
> git pull
```

## Submitting bug fixes 

```
> git branch bishtgautam/lnd/bug-fix-for-pgi
> git checkout bishtgautam/lnd/bug-fix-for-pgi
> git add models/lnd/clm/src/biogeophys/TemperatureType.F90
> git commit

Fixed a bug in CLM to NaN when using PGI on Titan …

A B1850C5L45BGC and ICLM45BGC case ran successfully after this fix on Titan,
when compiled with PGI. This commit resolves #165. 

> git push origin bishtgautam/lnd/bug-fix-for-pgi
```

## Rebasing
```
> git checkout bishtgautam/lnd/intel-14x-bugfix

# Determine the parent hash
> git log --pretty="%h %p" -n 1
830d81d cab58cf

# Change the parent of '830d81d' to be 'b7663ce' instead of 'cab58cf' 
> git rebase --onto b7663ce cab58cf

# If something went wrong and you want to redo
#> git reset --hard origin/bishtgautam/lnd/intel-14x-bugfix

# Push the change in the remote
> git push origin +bishtgautam/lnd/intel-14x-bugfix
# OR, you can push the change into a local repository
> git push ACME-bishtgautam-test bishtgautam/lnd/intel-14x-bugfix
```

## Renaming a branch (local and remote)
```
# Move the branch <oldbranch> <newbranch>
> git branch -m bishtgautam/lnd/intel-14x-bugfix bishtgautam/lnd/bug-fix-intel-14x
# Delete the remote branch with name <oldbranch> 
> git push origin :bishtgautam/lnd/intel-14x-bugfix
# Recreate the remote with name <newbranch>
> git push origin bishtgautam/lnd/bug-fix-intel-14x
```

## Finding files changes in a commit
```
git --no-pager show --pretty="format:" --name-only
```


## Pushing changes from an ACME-fork into ACME

Pushing changes from 'ckoven/lnd/clm-ed-branch' of ckoven/ACME.git into ACME-Climate/ACME.git 

Two possible ways:

* **Two-step-method**: Push the changes from 'ckoven/lnd/clm-ed-branch' into a local copy of 
   ACME-Climate/ACME.git and then push into ACME-Climate/ACME.git

```
export BASE_DIR=$PWD
git clone git@github.com:ACME-Climate/ACME.git ACME-fork
git clone git@github.com:ckoven/ACME.git ACME-ckoven-fork

cd ${BASE_DIR}/ACME-ckoven-fork/
git checkout ckoven/lnd/clm-ed-branch
git remote -v
git remote add acme-fork-local ${BASE_DIR}/ACME-fork
git remote -v
git push acme-fork-local ckoven/lnd/clm-ed-branch
```

* **One-step-method**: Push the changes from 'ckoven/lnd/clm-ed-branch' into a local copy of 
   ACME-Climate/ACME.git and then push into ACME-Climate/ACME.git

```
cd ${BASE_DIR}/ACME-ckoven-fork/
git remote -v
git remote add acme-fork-git https://github.com/ACME-Climate/ACME.git
git push acme-fork-git ckoven/lnd/clm-ed-branch

```

# ACME

## Testing

### Generating baselines

```
./create_test \
-xml_mach edison \
-xml_compiler intel \
-xml_category acme_developer \
-testid acme_dev_bb1a6da \
-testroot /project/projectdirs/acme/gbisht/tests/bb1a6da-acme_developer \
-baselineroot /project/projectdirs/acme/gbisht/baselines \
-generate bb1a6da-acme_developer \
-project acme

# Case directory: /project/projectdirs/acme/gbisht/tests/bb1a6da-acme_developer
# Baseline directory: /project/projectdirs/acme/gbisht/baselines/bb1a6da-acme_developer

```

### Comparing baselines

```
./create_test \
-xml_mach edison \
-xml_compiler intel \
-xml_category acme_developer \
-testid acme_dev_52b9226 \
-testroot /project/projectdirs/acme/gbisht/tests/52b9226-acme_developer \
-baselineroot /project/projectdirs/acme/gbisht/baselines \
-compare d97ef09-acme_developer \
-project acme

# Case directory: /project/projectdirs/acme/gbisht/tests/52b9226-acme_developer
# Baseline directory: /project/projectdirs/acme/gbisht/baselines/d97ef09-acme_developer

```
~~~~