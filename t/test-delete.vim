source plugin/surround.vim
source t/util/util.vim

describe 'ds'

  before
    new
    set clipboard=
    set selection=inclusive
    call setreg('"', '')
  end

  after
    close!
  end

  it 'deletes surrounding single quotes'
    put! = \"\'world\'\"
    Expect getline(1) == "\'world\'"
    normal ds'
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding double quotes'
    put! = '\"world\"'
    Expect getline(1) == '"world"'
    normal ds"
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding backticks'
    put! = '`world`'
    Expect getline(1) == '`world`'
    normal ds`
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding parenthesis'
    put! = '_( world )_'
    normal f(
    normal ds)
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding parenthesis, trimming whitespaces'
    put! = '_( world )_'
    normal f(
    normal ds(
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding parenthesis (aliased)'
    put! = '_( world )_'
    normal f(
    normal dsb
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding square brackets'
    put! = '_[ world ]_'
    normal f[
    normal ds]
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding square brackets, trimming whitespaces'
    put! = '_[ world ]_'
    normal f[
    normal ds[
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding square brackets (aliased)'
    put! = '_[ world ]_'
    normal f[
    normal dsr
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding curly brackets'
    put! = '_{ world }_'
    normal f{
    normal ds}
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding curly brackets, trimming whitespaces'
    put! = '_{ world }_'
    normal f{
    normal ds{
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding curly brackets (aliased)'
    put! = '_{ world }_'
    normal f{
    normal dsB
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding angle brackets'
    put! = '_< world >_'
    normal f<
    normal ds>
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding angle brackets, trimming whitespaces'
    put! = '_< world >_'
    normal f<
    normal ds<
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding angle brackets (aliased)'
    put! = '_< world >_'
    normal f<
    normal dsa
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding exclamation points'
    put! = '!world!'
    normal fw
    normal ds!
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding number signs'
    put! = '#world#'
    normal fw
    normal ds#
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding dollar signs'
    put! = '$world$'
    normal fw
    normal ds$
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding percent signs'
    put! = '%world%'
    normal fw
    normal ds%
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding ampersands'
    put! = '&world&'
    normal fw
    normal ds&
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding asterisks'
    put! = '*world*'
    normal fw
    normal ds*
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding plus signs'
    put! = '+world+'
    normal fw
    normal ds+
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding minus signs'
    put! = '-world-'
    normal fw
    normal ds-
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding commas'
    put! = ',world,'
    normal fw
    normal ds,
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding dots'
    put! = '.world.'
    normal fw
    normal ds.
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding colons'
    put! = ',world,'
    normal fw
    normal ds,
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding semicolons'
    put! = ';world;'
    normal fw
    normal ds;
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding equals signs'
    put! = '=world='
    normal fw
    normal ds=
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding question marks'
    put! = '?world?'
    normal fw
    normal ds?
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding at signs'
    put! = '@world@'
    normal fw
    normal ds@
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding carets'
    put! = '^world^'
    normal fw
    normal ds^
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding underscores'
    put! = '_world_'
    normal fw
    normal ds_
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding pipes'
    put! = '\|world\|'
    normal fw
    normal ds|
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding tildes'
    put! = '~world~'
    normal fw
    normal ds~
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding C comment (forward slash)'
    put! = '/* world */'
    normal fw
    normal ds/
    Expect getline(1) == 'world'
  end

  it 'deletes surrounding C comment (mutliline)'
    put = '/*'
    put = 'hello'
    put = 'world'
    put = '*/'
    Expect getline(2) == '/*'
    Expect getline(3) == 'hello'
    Expect getline(4) == 'world'
    Expect getline(5) == '*/'
    normal 3G
    normal ds/
    Expect getline(2) == ''
    Expect getline(3) == 'hello'
    Expect getline(4) == 'world'
    Expect getline(5) == ''
  end

  it 'deletes surrounding spaces, when cursor at the beginning of word'
    put! = 'hello world hello'
    normal fw
    execute "normal ds\<space>\<space>"
    Expect getline(1) == 'helloworldhello'
  end

  it 'deletes surrounding spaces, when cursor in the middle of word'
    put! = 'hello world hello'
    normal fr
    execute "normal ds\<space>\<space>"
    Expect getline(1) == 'helloworldhello'
  end

  it 'deletes surrounding spaces, when cursor in the very first space'
    put! = 'hello world good morning'
    " usually if cursor is on space, it's interpreted as a closing space
    " but if it's the very first space, it's interpreted as an opening space
    execute "normal f\<space>"
    Expect CursorChar() == ' '
    execute "normal ds\<space>\<space>"
    Expect getline(1) == 'helloworldgood morning'
  end

  it 'deletes surrounding char and trims whitespace afterwards'
    put! = ' [{  world  }] '
    normal fw
    execute "normal ds\<space>}"
    Expect getline(1) == ' [world] '
  end

  it 'allows a count to reach an outer target (count=1, before char)'
    put! = '(_(_(world)_)_)'
    normal fw
    normal ds1)
    Expect getline(1) == '(_(_world_)_)'
  end

  it 'allows a count to reach an outer target (count=2, before char)'
    put! = '(_(_(world)_)_)'
    normal fw
    normal ds2)
    Expect getline(1) == '(__(world)__)'
  end

  it 'allows a count to reach an outer target (count=2, before ds)'
    put! = '(_(_(world)_)_)'
    normal fw
    normal 2ds)
    Expect getline(1) == '(__(world)__)'
  end

  it 'allows a count to reach an outer target (combined counts)'
    put! = '(_(_(_(_(_(world)_)_)_)_)_)'
    normal fw
    normal 3ds2)
    Expect getline(1) == '_(_(_(_(_(world)_)_)_)_)_'
  end

  it 'ignores non-surrounding input character (clean reg)'
    call setreg('"', "")
    put! = '(world)'
    normal ds]
    Expect getline(1) == '(world)'
  end

  it 'ignores non-surrounding input character (dirty reg)'
    call setreg('"', "something")
    put! = '(world)'
    normal ds]
    Expect getline(1) == '(world)'
  end

  it 'preserves unnamed register on success'
    call setreg('"', "something", "b")
    put! = '(world)'
    normal ds)
    Expect getline(1) == 'world'
    Expect getreg('"') == 'something'
    Expect getregtype('"') == "\x169"
  end

  it 'preserves unnamed register on failure'
    call setreg('"', "something", "b")
    put! = '(world)'
    normal ds]
    Expect getline(1) == '(world)'
    Expect getreg('"') == 'something'
    Expect getregtype('"') == "\x169"
  end

end
