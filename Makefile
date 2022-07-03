#!/usr/bin/make

SOURCEDIR	:= ./pdf
OUTPUTDIR	:= .
SHORTFILEDIR	:= shortfilename
LONGFILEDIR	:= longfilename

# pdftotextコマンドを利用する
# 未インストールの場合は次のコマンドでインストールする(ubuntuの場合)
# sudo apt-get install poppler-utils
PROGRAM		:= pdftotext
OPTIONS		:= -layout -nopgbrk -enc UTF-8 -eol unix
# -layout         : maintain original physical layout
# -nopgbrk        : don't insert page breaks between pages
# -enc <string>   : output text encoding name
# -eol <string>   : output end-of-line convention (unix, dos, or mac)

# コマンドループ用の、ファイル名のみのリストを作成
SHORTFILENAMES	:= $(notdir $(wildcard $(SOURCEDIR)/$(SHORTFILEDIR)/*.pdf))
LONGFILENAMES	:= $(notdir $(wildcard $(SOURCEDIR)/$(LONGFILEDIR)/*.pdf))

# pdftotextのコマンド構築用関数
# (コマンド行の次の空行を消さない事。無いとforeachで行が繋がってしまう。)
define EXEC
	$(PROGRAM) $(OPTIONS) $(SOURCEDIR)/${1} $(OUTPUTDIR)/$(subst .pdf,.txt,${1})

endef

# 出力フォルダが存在しない場合は作成
.PHONY: makedir
makedir:
	mkdir -p $(OUTPUTDIR)/$(SHORTFILEDIR)
	mkdir -p $(OUTPUTDIR)/$(LONGFILEDIR)

# 出力フォルダを削除する
.PHONY: clean
clean:
	rm -rf $(OUTPUTDIR)/$(SHORTFILEDIR)
	rm -rf $(OUTPUTDIR)/$(LONGFILEDIR)

# 変換処理を実行する
.DEFAULT_GOAL := all
.PHONY: all
all: makedir
	$(foreach FILE, $(SHORTFILENAMES), $(call EXEC,$(SHORTFILEDIR)/$(FILE)))
	$(foreach FILE, $(LONGFILENAMES), $(call EXEC,$(LONGFILEDIR)/$(FILE)))

