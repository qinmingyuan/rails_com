require 'mina/default'

set :branch, 'master'
set :remove_git_dir, true
set :remote, 'origin'
set :git_not_pushed_message, -> { "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)} before deploying" }

namespace :git do
  desc 'Clones the Git repository to the current path.'
  task :clone do
    ensure!(:repository)
    ensure!(:deploy_to)
    if set?(:commit)
      comment %{Using git commit \\"#{fetch(:commit)}\\"}
      command %{git clone "#{fetch(:repository)}" . --recursive}
      command %{git checkout -b current_release "#{fetch(:commit)}" --force}
    else
      command %{
        if [ ! -d "#{fetch(:deploy_to)}/scm" ]; then
          echo "-----> Cloning the Git repository"
          #{echo_cmd %[git clone --recurse-submodules --separate-git-dir #{fetch(:deploy_to)}/scm #{fetch(:repository)} #{fetch(:deploy_to)}/repo]}
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd #{fetch(:deploy_to)}/repo && git pull --force #{fetch(:repository)} #{fetch(:branch)}:#{fetch(:branch)})]}
        fi &&
        echo "-----> Using git branch '#{fetch(:branch)}'" &&
        #{echo_cmd %[echo 'gitdir: #{fetch(:deploy_to)}/scm' >> .git]}
        #{echo_cmd %[git checkout --force]}
        #{echo_cmd %[git submodule update --init]}
      }, quiet: true
    end
    comment %{Using this git commit}
    command %{git rev-parse HEAD > .mina_git_revision}
    command %{git --no-pager log --format="%aN (%h):%n> %s" -n 1}
    if fetch(:remove_git_dir)
      command %{rm -rf .git}
    end
  end

  desc 'Prints out current revision'
  task :revision do
    ensure!(:deploy_to)
    command %{cat #{fetch(:current_path)}/.mina_git_revision}
  end

  desc 'Ensures local repository is pushed to remote'
  task :ensure_pushed do
    run :local do
      comment %{Ensuring everything is pushed to git}
      command %{
        if [ $(git log #{fetch(:remote)}/#{fetch(:branch)}..#{fetch(:branch)} | wc -l) -ne 0 ]; then
          echo "! #{fetch(:git_not_pushed_message)}"
          exit 1
        fi
      }
    end
  end
end
