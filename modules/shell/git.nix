{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      act
      dura
      gitui
      gitAndTools.gh
      gitAndTools.git-open
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
      tig
    ];

    # easier gitignore fetching (fish)
    hm.programs.fish.functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    # Prevent x11 askPass prompt on git push:
    programs.ssh.askPassword = "";

    hm.programs.git = {
      enable = true;
      package = pkgs.gitFull;
      delta.enable = false;
      difftastic = {
        enable = true;
      };

      aliases = {
        unadd = "reset HEAD";

        # Data Analysis:
        ranked-authors = "!git authors | sort | uniq -c | sort -n";
        emails = ''
          !git log --format="%aE" | sort -u
        '';
        email-domains = ''
          !git log --format="%aE" | awk -F'@' '{print $2}' | sort -u
        '';
        amend = "!git commit --amend -C HEAD";
       };

      attributes = ["*.lisp diff=lisp" "*.el diff=lisp" "*.org diff=org"];

      ignores = [
        # General:
        "*.bloop"
        "*.bsp"
        "*.metals"
        "*.metals.sbt"
        "*metals.sbt"
        "*.direnv"
        "*.envrc"
        "*hie.yaml"
        "*.mill-version"
        "*.jvmopts"

        # Emacs:
        "*~"
        "*.*~"
        "\\#*"
        ".\\#*"

        # OS-related:
        ".DS_Store?"
        ".DS_Store"
        ".CFUserTextEncoding"
        ".Trash"
        ".Xauthority"
        "thumbs.db"
        "Thumbs.db"
        "Icon?"

        # Compiled residues:
        "*.class"
        "*.exe"
        "*.o"
        "*.pyc"
        "*.elc"
        # Created by https://www.toptal.com/developers/gitignore/api/haskell
        # Edit at https://www.toptal.com/developers/gitignore?templates=haskell

        ### Haskell ###
        "dist"
        "dist-*"
        "cabal-dev"
        "*.o"
        "*.hi"
        "*.hie"
        "*.chi"
        "*.chs.h"
        "*.dyn_o"
        "*.dyn_hi"
        ".hpc"
        ".hsenv"
        ".cabal-sandbox/"
        "cabal.sandbox.config"
        "*.prof"
        "*.aux"
        "*.hp"
        "*.eventlog"
        ".stack-work/"
        "cabal.project.local"
        "cabal.project.local~"
        ".HTF/"
        ".ghc.environment.*"

        # End of https://www.toptal.com/developers/gitignore/api/haskell

        # Created by https://www.toptal.com/developers/gitignore/api/tags
        # Edit at https://www.toptal.com/developers/gitignore?templates=tags

        ### Tags ###
        # Ignore tags created by etags, ctags, gtags (GNU global) and cscope
        #
        "TAGS"
        ".TAGS"
        "!TAGS/"
        "tags"
        ".tags"
        "!tags/"
        "gtags.files"
        "GTAGS"
        "GRTAGS"
        "GPATH"
        "GSYMS"
        "cscope.files"
        "cscope.out"
        "cscope.in.out"
        "cscope.po.out"

        # End of https://www.toptal.com/developers/gitignore/api/tags

      ];

      userName = "Providence Salumu";
      userEmail = "Providence.Salumu@smunix.com";
      signing = {
        signByDefault = true;
        key = "5A32FFADFC0F3C58";
      };

      extraConfig = {
        init.defaultBranch = "main";
        core = {
          editor = "emacsclient -t";
          # pager = "diff-so-fancy | less --tabs=4 -RFX";
          whitespace = "trailing-space,space-before-tab";
        };

        tag.gpgSign = true;
        pull.rebase = true;
        push = {
          default = "current";
          gpgSign = "if-asked";
          autoSquash = true;
        };

        github.user = "smunix";
        gitlab.user = "smunix";

        filter = {
          required = true;
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          clean = "git-lfs clean -- %f";
        };

        safe.directory = [ "/etc/snowflake.git" ];

        url = {
          "https://github.com/".insteadOf = "gh:";
          "git@github.com:".insteadOf = "ssh+gh:";
          "git@github.com:smunix/".insteadOf = "gh:/";
          "https://gitlab.com/".insteadOf = "gl:";
          "https://gist.github.com/".insteadOf = "gist:";
          "https://bitbucket.org/".insteadOf = "bb:";
        };

        diff = {
          "lisp".xfuncname = "^(((;;;+ )|\\(|([ \t]+\\(((cl-|el-patch-)?def(un|var|macro|method|custom)|gb/))).*)$";
          "org".xfuncname = "^(\\*+ +.*)$";
        };

        credential = {
          "https://github.com".helper = "!gh auth git-credential";
          "https://gist.github.com".helper = "!gh auth git-credential";
        };
      };
    };
  };
}
