<kbd>
<img src="./img/randomator_1440_logo.png" alt="A serious randomator" style="height: 300px; width:300px;"/>
</kbd>

## Randomator 1440
Low dependency randomness for all your educational needs.

See [LICENSE.md](LICENSE.md) for details on distribution.

All rights reserved on the logo.

## Warnings

- Randomator 1440 should be as dependable as /dev/random.
- Experimental script for education purposes with no warranties of any kind.

## Dependencies

- A bash compatible shell
- Updated GNU core utils (or compatible):
	- od https://en.wikipedia.org/wiki/Od_(Unix)
	- paste https://en.wikipedia.org/wiki/Paste_(Unix)
	- cut https://en.wikipedia.org/wiki/Cut_(Unix)
	- sha512sum https://en.wikipedia.org/wiki/Sha1sum
	- echo https://en.wikipedia.org/wiki/Echo_(command)
	- tr https://en.wikipedia.org/wiki/Tr_(Unix)
	- date 
- Updated GNU findutils (or compatible):
	- xargs https://en.wikipedia.org/wiki/Xargs
- an existing and working /dev/random


### Usage

```
./scripts/randomator_1440.sh [options]
```
Where Options:
-	 ```--help```: Show usage
- ```<dir>```:	Use ```<dir>``` as output directory

#### Notes

- ```<dir>``` will be created if it does not exist
- Filename will be in the format YYYY-MM-dd.json, e.g 2023-01-16.json

#### Examples

- ```./scripts/randomator_1440.sh```
     will create a json file in the current directory
	
- ```./scripts/randomator_1440.sh /some/folder```
     will create a json file in /some/folder/

### Example JSON Output

The content of the file will contain JSON as in this example:

```{
	"2023-01-16": {
		"values_hash": {
			"type:": "sha512",
			"hash": <sha512 hash of the json string of the field values>
		},
		"values": {
			"unsigned_32_bit": [
				4107879905,
				79905,
				... contains a total of 24*60 entries
			],
			"signed_32_bit": [
				-1877367571,
				7367571,
				... contains a total of 24*60 entries
			],
			"byte": [
				63,
				127,
				... contains a total of 24*60 entries
			],
			"coin_flips": [
				0,
				1,
				... contains a total of 24*60 entries
			]
		}
	}
}
```
