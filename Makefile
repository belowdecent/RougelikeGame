collection_flags := -collection:src=src

all:
	odin build src $(collection_flags) -out:build/RougelikeGame

run:
	odin run src $(collection_flags) -out:build/RougelikeGame
