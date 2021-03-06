source plugin/surround.vim
source t/util/util.vim

describe 'surround'

  before
    new
    set clipboard=
    set selection=inclusive
    call setreg('"', '')
  end

  after
    close!
    call setreg('"', '')
  end

  it 'surrounds with single quotes'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw'
    Expect getline(1) == "'world'"
  end

  it 'surrounds with double quotes'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw"
    Expect getline(1) == '"world"'
  end

  it 'surronds with backticks'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw`
    Expect getline(1) == '`world`'
  end

  it 'surrounds with parenthesis'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw)
    Expect getline(1) == '(world)'
  end

  it 'surrounds with parenthesis (visual character-wise)'
    put! = 'world'
    normal viwS)
    Expect getline(1) == '(world)'
  end

  it 'surrounds with parenthesis (visual block-wise)'
    put! = '123456'
    put  = '777888'
    put  = '999000'
    normal gg
    normal f3
    execute "normal \<c-v>2jl"
    normal S)
    Expect getline(1) == '12(34)56'
    Expect getline(2) == '77(78)88'
    Expect getline(3) == '99(90)00'
  end

  it 'surrounds with parenthesis and extra spaces'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw(
    Expect getline(1) == '( world )'
  end

  it 'surrounds with parenthesis (aliased)'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiwb
    Expect getline(1) == '(world)'
  end

  it 'surrounds with square brackets'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw]
    Expect getline(1) == '[world]'
  end

  it 'surrounds with square brackets and extra spaces'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw[
    Expect getline(1) == '[ world ]'
  end

  it 'surrounds with square brackets (aliased)'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiwr
    Expect getline(1) == '[world]'
  end

  it 'surrounds with curly brackets'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw}
    Expect getline(1) == '{world}'
  end

  it 'surrounds with curly brackets and extra spaces'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw{
    Expect getline(1) == '{ world }'
  end

  it 'surrounds with curly brackets (aliased)'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiwB
    Expect getline(1) == '{world}'
  end

  it 'surrounds with angle brackets'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw>
    Expect getline(1) == '<world>'
  end

  it 'surrounds with angle brackets (aliased)'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiwa
    Expect getline(1) == '<world>'
  end

  it 'surrounds with slash'
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw/
    Expect getline(1) == '/world/'
  end

  it 'surrounds with spaces'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiw\<space>\<space>"
    Expect getline(1) == ' world '
  end

  it 'surrounds with character and extra spaces'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiw\<space>_"
    Expect getline(1) == '_ world _'
  end

  it 'surrounds as paragraph'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiwp"
    Expect getline(1) == ''
    Expect getline(2) == 'world'
    Expect getline(3) == ''
    Expect getline(4) == ''
    normal G
    Expect line(".") == 5
  end

  it "surrounds with tag ('t' mapping)"
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwtdiv\<cr>"
    Expect getline(1) == '<div>hello</div>'
  end

  it "surrounds with tag ('T' mapping)"
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwTdiv\<cr>"
    Expect getline(1) == '<div>hello</div>'
  end

  it "surrounds with tag ('<' mapping)"
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiw<div\<cr>"
    Expect getline(1) == '<div>hello</div>'
  end

  it 'surrounds with tag in separate lines (<c-t> mapping)'
    set expandtab
    set shiftwidth=2
    put! = 'hello'
    execute "normal ysiw\<C-T>div\<cr>"
    Expect getline(1) == "<div>"
    Expect getline(2) == "  hello"
    Expect getline(3) == "</div>"
  end

  it 'surrounds with tags (visual block-wise); <c-t> has no extra effect'
    put! = '<div>32</div>'
    put  = '<div>53</div>'
    put  = '<div>74</div>'
    normal gg
    normal f3
    execute "normal \<c-v>2jl"
    execute "normal S\<C-T>p\<cr>"
    " In normal mode, it surrounds in separate lines
    " In visual block, it simply surrounds inline
    Expect getline(1) == '<div><p>32</p></div>'
    Expect getline(2) == '<div><p>53</p></div>'
    Expect getline(3) == '<div><p>74</p></div>'
  end

  it 'surrounds with tag in separate lines, indented (et, sw=2)'
    set expandtab
    set shiftwidth=2
    put! = '    hello'
    execute "normal ysiw\<C-T>div\<cr>"
    Expect getline(1) == "    <div>"
    Expect getline(2) == "      hello"
    Expect getline(3) == "    </div>"
  end

  it 'surrounds with tag in separate lines, indented (et, sw=4)'
    set expandtab
    set shiftwidth=4
    put! = '    hello'
    execute "normal ysiw\<C-T>div\<cr>"
    Expect getline(1) == "    <div>"
    Expect getline(2) == "        hello"
    Expect getline(3) == "    </div>"
  end

  it 'surrounds with tag in separate lines, indented (noet, sw=4, ts=4)'
    set noexpandtab
    set shiftwidth=4
    set tabstop=4
    let b:surround_indent=0
    put! = '		hello'
    Expect getline(1) == "\t\thello"
    execute "normal ysiw\<C-T>div\<cr>"
    Expect getline(1) == "\t\t<div>"
    Expect getline(2) == "\t\t\thello"
    Expect getline(3) == "\t\t</div>"
  end

  it 'surrounds with tag that has attributes'
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwtdiv id=\"content\" class=\"row\"\<cr>"
    Expect getline(1) == "<div id=\"content\" class=\"row\">hello</div>"
  end

  it 'prepends with tag'
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwtinput/\<cr>"
    Expect getline(1) == "<input />hello"
  end

  it 'does not surround with empty tag'
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwt\<cr>"
    Expect getline(1) == 'hello'
  end

  it "surrounds with tag, finishing input when '>' is pressed"
    put! = 'hello'
    Expect getline(1) == 'hello'
    execute "normal ysiwtdiv>"
    Expect getline(1) == '<div>hello</div>'
    Expect maparg('>', 'c') == ''
  end

  it "surrounds with tag, erasing existing '>' cmd-line mapping (bug)"
    put! = 'hello'
    Expect getline(1) == 'hello'
    cnoremap > x
    execute "normal ysiwtdiv>"
    Expect getline(1) == '<div>hello</div>'
    Expect maparg('>', 'c') == ''
    " line 170 always returns true -> if !maparg(">","c")
    " should be instead -> if maparg(">","c") !=# ""
    " making the spec in this case be:
    " 'not finishing input when '>' is pressed and preserving existing mapping'
  end

  it 'surrounds with function call'
    put! = '2, 3, 5'
    Expect getline(1) == '2, 3, 5'
    execute "normal ys$faverage\<cr>"
    Expect getline(1) == 'average(2, 3, 5)'
  end

  it 'surrounds with function call and extra spaces'
    put! = '2, 3, 5'
    Expect getline(1) == '2, 3, 5'
    execute "normal ys$Faverage\<cr>"
    Expect getline(1) == 'average( 2, 3, 5 )'
  end

  it 'surrounds with function call, removing trailing parenthesis'
    put! = '2, 3, 5'
    Expect getline(1) == '2, 3, 5'
    execute "normal ys$faverage(\<cr>"
    Expect getline(1) == 'average(2, 3, 5)'
  end

  it 'does not surround with empty function call'
    put! = '2, 3, 5'
    Expect getline(1) == '2, 3, 5'
    execute "normal ys$F\<cr>"
    Expect getline(1) == '2, 3, 5'
  end

  it "surrounds latex ('l' mapping)"
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiwlcenter\<cr>"
    Expect getline(1) == '\begin{center}world\end{center}'
  end

  it 'surrounds latex (\ mapping)'
    put! = 'world'
    Expect getline(1) == 'world'
    execute 'normal ysiw\' . "center\<cr>"
    Expect getline(1) == '\begin{center}world\end{center}'
  end

  it 'does not surround empty latex'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiwl\<cr>"
    Expect getline(1) == 'world'
  end

  it 'adds leading space'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiws"
    Expect getline(1) == ' world'
  end

  it 'adds leading colon'
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiw:"
    Expect getline(1) == ':world'
  end

  it "ignores alphabetic chars that don't have special semantics"
    put! = 'world'
    Expect getline(1) == 'world'
    execute "normal ysiwk"
    Expect getline(1) == 'world'
  end

  it 'surrounds cursor with curly braces in insert mode'
    set expandtab
    set shiftwidth=2
    put! = 'world'
    normal fl
    execute "normal i\<C-G>s\<C-]>hello\<esc>"
    Expect getline(1) == "wor{"
    Expect getline(2) == "  hello"
    Expect getline(3) == "}ld"
  end

  it 'surrounds with buffer custom template (\r placeholder)'
    " buffer custom template for '-' (ASCII 45)
    " content will be at \r
    let b:surround_45 = "<?php \r ?>"
    put! = 'world'
    execute 'normal ysiw-'
    Expect getline(1) == '<?php world ?>'
  end

  it 'surrounds with buffer custom template (\n placeholder)'
    " buffer custom template for '-' (ASCII 45)
    " content will be at \n
    let b:surround_45 = "<?php hello, \n ?>"
    put! = 'world'
    execute 'normal ysiw-'
    Expect getline(1) == '<?php hello, world ?>'
    " Note:
    " if you have multiple \n's then the result is a bit weird:
    " let b:surround_45 = "<?php good\n morning\n?>"
    " outputs:
    "<?php good
    " morningworld morning
    "?>
    " see:
    " echo matchstr("<?php good\n morning\n?>",'.*\ze\n')
    " echo matchstr("<?php good\n morning\n?>",'\n\zs.*')
  end

  it 'surrounds with global custom template'
    " global custom template for '-' (ASCII 45)
    let g:surround_45 = "<?php \r ?>"
    put! = 'world'
    execute 'normal ysiw-'
    Expect getline(1) == '<?php world ?>'
  end

  it 'overrides global template with buffer template'
    " global custom template for '-' (ASCII 45)
    let g:surround_45 = "<?php \r ?>"
    " buffer custom template for '-' (ASCII 45)
    let b:surround_45 = "<?perl \r ?>"
    put! = 'world'
    execute 'normal ysiw-'
    Expect getline(1) == '<?perl world ?>'
  end

  it 'overrides default surround with buffer custom template'
    " buffer custom template for ')' (ASCII 41)
    let b:surround_41 = "<?php \r ?>"
    put! = 'world'
    execute 'normal ysiw)'
    Expect getline(1) == '<?php world ?>'
  end

  it 'surrounds with lisp function call'
    put! = '2 3 5'
    Expect getline(1) == '2 3 5'
    execute "normal ys$\<C-F>average\<cr>"
    Expect getline(1) == '(average 2 3 5)'
  end

  it 'operates on linewise motion'
    set filetype=vim
    put! = 'hello'
    put  = 'good'
    put  = 'morning'
    normal ys2k)
    " puts the surrounding chars in separate lines
    Expect getline(1) == '('
    Expect getline(2) == "hello"
    Expect getline(3) == "good"
    Expect getline(4) == "morning"
    Expect getline(5) == ')'
  end

  it 'surrounds on visual linewise (1)'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = 'world'
    normal VS)
    " puts the surrounding chars in separate lines
    Expect getline(1) == '('
    Expect getline(2) == "  world"
    Expect getline(3) == ')'
  end

  it 'surrounds on visual linewise (2)'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = 'world'
    normal VS(
    " should trim trailing whitespaces
    " (\s => (
    Expect getline(1) == '('
    Expect getline(2) == "  world"
    " should trim leading whitespaces
    " \s) => )
    Expect getline(3) == ')'
  end

  it 'surrounds on visual linewise (3)'
    set expandtab
    set shiftwidth=2
    " buffer custom template for '-' (ASCII 45)
    let b:surround_45 = "<?php          \r          ?>"
    let b:surround_indent=0
    put! = 'hello'
    put  = 'world'
    normal VkS-
    " puts the surrounding chars in separate lines, trimming whitespaces
    Expect getline(1) == '<?php'
    Expect getline(2) == "  hello"
    Expect getline(3) == "  world"
    Expect getline(4) == '?>'
  end

  it 'surrounds on visual linewise, preserving padding (1)'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = '    hello'
    put  = '  good'
    put  = '  morning'
    " start visual mode from top to bottom
    normal gg
    normal V2jS)
    " - the surrounding chars will be in separate lines
    " - the surrounding chars will be at the same level of indentation as
    " the first line
    " - the target lines will be indented one level deeper
    Expect getline(1) == '    ('
    Expect getline(2) == "      hello"
    Expect getline(3) == "    good"
    Expect getline(4) == "    morning"
    Expect getline(5) == '    )'
  end

  it 'surrounds on visual linewise, preserving padding (2)'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = '    hello'
    put  = '  good'
    put  = '  morning'
    " start visual mode from bottom to top
    normal V2kS)
    " - the surrounding chars will be in separate lines
    " - the surrounding chars will be at the same level of indentation as
    " the first line
    " - the target lines will be indented one level deeper
    Expect getline(1) == '    ('
    Expect getline(2) == "      hello"
    Expect getline(3) == "    good"
    Expect getline(4) == "    morning"
    Expect getline(5) == '    )'
  end

  it 'surrounds on visual linewise, preserving padding (3)'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = '    hello'
    put  = '  good'
    put  = '  morning'
    normal gg
    execute "normal V2jS\<C-T>div\<cr>"
    " - the surrounding chars will be in separate lines
    " - the surrounding chars will be at the same level of indentation as
    " the first line
    " - the target lines will be indented one level deeper
    Expect getline(1) == '    <div>'
    Expect getline(2) == "      hello"
    Expect getline(3) == "    good"
    Expect getline(4) == "    morning"
    Expect getline(5) == '    </div>'
  end

  it 'surrounds on visual linewise, preserving padding (4); paragraph'
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = '    hello'
    put  = '  good'
    put  = '  morning'
    normal gg
    normal V2jSp
    " - the surrounding chars will be in separate lines
    " - the surrounding chars will be at the same level of indentation as
    " the first line
    " - the target lines will *not* be indented any further
    Expect getline(1) == '    '
    Expect getline(2) == "    hello"
    Expect getline(3) == "  good"
    Expect getline(4) == "  morning"
    Expect getline(5) == '    '
    Expect getline(6) == '    '
  end

  it "surrounds on visual linewise; 'extra space' feature has no effect"
    set expandtab
    set shiftwidth=2
    let b:surround_indent=0
    put! = 'world'
    " Compare with ysiw\<space>a
    execute "normal VS\<space>a"
    " As opposed to '< '
    Expect getline(1) == '<'
    Expect getline(2) == "  world"
    " As opposed to ' >'
    Expect getline(3) == '>'
  end

  it "operates on the current line ('yss')"
    put! = 'hello, world!'
    Expect getline(1) == 'hello, world!'
    normal fw
    execute 'normal yss)'
    Expect getline(1) == '(hello, world!)'
  end

  it "operates on the current line, ignoring leading whitespaces ('yss')"
    put! = '  hello, world!'
    Expect getline(1) == '  hello, world!'
    normal fw
    execute 'normal yss)'
    Expect getline(1) == '  (hello, world!)'
    Expect CursorChar() == '('
  end

  it "operates on count lines ('yss')"
    put! = 'apples bananas'
    put = 'watermelons strawberries'
    put = 'oranges grapes'
    normal gg
    Expect getline('.') == 'apples bananas'
    execute 'normal 3yss>'
    " when manually putting angle brackets
    " and using '=' operator
    " indentation won't be affected (at least in my setup)
    " that's why '>' is being used here
    Expect getline(1) == '<apples bananas'
    Expect getline(2) == 'watermelons strawberries'
    Expect getline(3) == 'oranges grapes>'
  end

  " Still don't know how to make this pass
  " maybe it depends on some additional setting that is in my vimrc
  " it "operates on count lines, indented ('yss')"
  "   put! = 'apples bananas'
  "   put = 'watermelons strawberries'
  "   put = 'oranges grapes'
  "   normal gg
  "   Expect getline('.') == 'apples bananas'
  "   execute 'normal 3yss)'
  "   " when manually putting parenthesis
  "   " and using '=' operator
  "   " vim will indent (at least in my setup)
  "   " that's why ')' is being used here
  "   Expect getline(1) == '(apples bananas'
  "   Expect getline(2) == ' watermelons strawberries'
  "   Expect getline(3) == ' oranges grapes)'
  " end

  it 'aborts if you press <esc>'
    put! = 'world'
    execute "normal ysiw\<esc>"
    execute "normal ihello, \<esc>"
    Expect getline(1) == "hello, world"
  end

  it 'aborts if you press <c-c>'
    put! = 'world'
    execute "normal ysiw\<c-c>"
    execute "normal ihello, \<esc>"
    Expect getline(1) == "hello, world"
  end

  it "works when 'selection' exclusive and normal mode"
    set selection=exclusive
    put! = 'world'
    Expect getline(1) == 'world'
    normal ysiw)
    Expect getline(1) == '(world)'
    Expect &selection == 'exclusive'
  end

  it "works when 'selection' exclusive and visual mode"
    set selection=exclusive
    put! = 'world'
    normal viwS)
    Expect getline(1) == '(world)'
    Expect &selection == 'exclusive'
  end

  it 'preserves unnamed register'
    set clipboard=
    call setreg('"', "something", "b")
    put! = 'world'
    normal ysiw)
    Expect getline(1) == '(world)'
    Expect &clipboard == ''
    Expect getreg('"') == 'something'
    Expect getregtype('"') == "\x169"
  end

  it "preserves 'clipboard' setting"
    set clipboard=unnamed,unnamedplus
    " I also wanted to test that temporarily removing unnamed and unnamedplus
    " (while surrounding) is important.
    " Maybe this doesn't make sense at all because 'clipboard' is applicable to:
    " {only in GUI versions or when the +xterm_clipboard feature is included}
    " My terminal vim doesn't have that feature, but 'clipboard' did seem to
    " work.
    "
    " My plan was to initially set reg " with a different value than reg *
    " but settting * seems to overwrite " in the tests, but not in my vim
    " maybe I'm missing some extra setting in tests or
    " to be honest, I don't know if the tests run the same version of vim as I
    " do
    call setreg('"', "bananas", "b")
    call setreg('*', "bananas", "b")
    Expect getreg('"') == 'bananas'
    Expect getreg('*') == 'bananas'
    Expect getreg('+') == 'bananas'
    put! = 'world'
    normal ysiw)
    Expect &clipboard == 'unnamed,unnamedplus'
    Expect getline(1) == '(world)'
    Expect getreg('"') == 'bananas'
    " I don't know why this is \x167 and not \x169 like other tests
    Expect getregtype('"') == "\x167"
    Expect getreg('*') == 'bananas'
    Expect getregtype('*') == "\x167"
    Expect getreg('+') == 'bananas'
    Expect getregtype('+') == "\x167"
  end

end
