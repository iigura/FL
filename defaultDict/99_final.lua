--[[ 99_final.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Exec [[
	"_from-to-iter" := "_loop_counter" @var "_to" @var
		<= if "_loop_counter" @var dup
			1 + "_loop_counter" !var
		  else
			end
			false
		  then ;
	"from-to" := do
				"_to" !var
				"_loop_counter" !var
				"_from-to-iter" @word >E
			  ;
]]

Exec [[
	"_lines-iter" := "_fh" @var read
					dup false = if
						"_fh" @var
						swap
						end
					then ;
	"lines" := do "_fh" !var
			   "_lines-iter" @word >E ;
]]

Exec [[ "load" := fopen lines foreach eval next close ; ]]

