
function set_lua_path_to() {
	lua_ver="$1"
	dest="$HOME/.luarocks/bins/$lua_ver"
	luabin="$HOME/.luarocks/bin"

	export LUA_PATH="$HOME/.luarocks/share/lua/$lua_ver/?.lua;$HOME/.luarocks/share/lua/$lua_ver/?/init.lua;/usr/share/lua/$lua_ver/?.lua;/usr/share/lua/$lua_ver/?/init.lua;/usr/lib/lua/$lua_ver/?.lua;/usr/lib/lua/$lua_ver/?/init.lua;./?.lua;./?/init.lua"
	export LUA_CPATH="$HOME/.luarocks/lib/lua/$lua_ver/?.so;/usr/lib/lua/$lua_ver/?.so;/usr/lib/lua/$lua_ver/loadall.so;./?.so"
	export PATH="$luabin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
	export PATH=$PATH:/opt/openresty/bin/:/opt/openresty/nginx/sbin/ #Automatically added by openresty package

	if [ -e $dest -a ! -d $dest ]; then # our destination already exist but it not a dir.
		mv $dest $dest.`date +%s`.bak
		mkdir -p $dest
	elif [ ! -e $dest ]; then
		# does not exist, lets create
		mkdir -p $dest
	fi

	if [ -d $luabin -a ! -h .luarocks/bin ]; then # if luabin is a folder, this is a default install, we need to move it.
		if [ "$(ls -A $dest)" ]; then # destination is not empty.
			# lets backup
			mv $luabin $dest/bin.`date +%s`.bak
		else
			# its empty, we can move is content instead.
			rmdir $dest; mv $luabin $dest
		fi
	elif [ ! -L $luabin -a -e $luabin ]; then # what? there is something else there..
		# lets backup
		mv $luabin $dest/bin.bak
	fi
	# and symlink
	ln -fsn $dest $luabin
}

function luavm() {
	if [ $# -eq 1 ]; then
		if [ "$1" = "5.1" ]; then
			set_lua_path_to "5.1"
			alias lua=lua5.1
			alias luac=luac5.1
		elif  [ "$1" = "5.2" ]; then
			set_lua_path_to "5.2"
			alias lua=lua5.2
			alias luac=luac5.2
		elif  [ "$1" = "5.3" ]; then
			set_lua_path_to "5.3"
			unalias lua 2> /dev/null
			unalias luac 2> /dev/null
		else
			echo "I'm not sure of what you want"
		fi
	else
		echo "I'm not sure of what you want"
	fi
}


function luarocks() {
	# lua 5.1 return the version to stderr.
	lua_version=`lua 2>&1 -v | sed 's/^Lua \([0-9]\.[0-9]\).*/\1/'`
	mkdir -p ~/.luarocks/bins/$lua_version
	luarocks-$lua_version $*
}
