#!/bin/sh


thepwd="$PWD"

traverse(){
IFS="
"
local realone="$(realpath "${1}")"
local realtwo="$(realpath "${2}")"

cd "${realone}"
for line in $(find . -maxdepth 1 -mindepth 1 -type f | sed "s#\\\#\\\\\\\#g"); do
	if ! [ -f "${realtwo}/$(echo "${line}" | cut -c 3-)" ]; then
		echo "File ${realone}/$(echo "${line}" | cut -c 3-) does not exist at ${realtwo}/)"
	else
		cmp --silent -- "${realone}/$(echo "${line}" | cut -c 3-)" "${realtwo}/$(echo "${line}" | cut -c 3-)"
		if [ "$?" != "0" ]; then
			echo "${realone}/$(echo "${line}" | cut -c 3-) does not match with ${realtwo}/$(echo "${line}" | cut -c 3-)"
		fi
	fi
done

cd "${realtwo}"
for line in $(find . -maxdepth 1 -mindepth 1 -type f | sed "s#\\\#\\\\\\\#g"); do
	if ! [ -f "${realone}/$(echo "${line}" | cut -c 3-)" ]; then
		echo "File ${realtwo}/$(echo "${line}" | cut -c 3-) does not exist at ${realone}/"
	fi
done

cd "${realone}"
for line in $(find . -maxdepth 1 -mindepth 1 -type d | sed "s#\\\#\\\\\\\#g"); do
	if ! [ -d "${realtwo}/$(echo "${line}" | cut -c 3-)" ]; then
		echo "Directory ${realtwo}/$(echo "${line}" | cut -c 3-) does not exist and does at ${realone}/$(echo "${line}" | cut -c 3-)"
	else
		traverse "${realone}/$(echo "${line}" | cut -c 3-)" "${realtwo}/$(echo "${line}" | cut -c 3-)"
	fi
done

cd "${realtwo}"
for line in $(find . -maxdepth 1 -mindepth 1 -type d | sed "s#\\\#\\\\\\\#g"); do
	if ! [ -d "${realone}/$(echo "${line}" | cut -c 3-)" ]; then
		echo "Directory ${realone}/$(echo "${line}" | cut -c 3-) does not exist and does at ${realtwo}/$(echo "${line}" | cut -c 3-)"
	fi
done

}

traverse "$1" "$2"