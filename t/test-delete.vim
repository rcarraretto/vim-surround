source plugin/surround.vim

function! CursorChar()
    return getline('.')[col('.')-1]
endfunction

describe 'delete surround'

  before
    new
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
    Expect CursorChar() == '('
    normal ds)
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding parenthesis, trimming whitespaces'
    put! = '_( world )_'
    normal f(
    Expect CursorChar() == '('
    normal ds(
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding parenthesis (aliased)'
    put! = '_( world )_'
    normal f(
    Expect CursorChar() == '('
    normal dsb
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding square brackets'
    put! = '_[ world ]_'
    normal f[
    Expect CursorChar() == '['
    normal ds]
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding square brackets, trimming whitespaces'
    put! = '_[ world ]_'
    normal f[
    Expect CursorChar() == '['
    normal ds[
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding square brackets (aliased)'
    put! = '_[ world ]_'
    normal f[
    Expect CursorChar() == '['
    normal dsr
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding curly brackets'
    put! = '_{ world }_'
    normal f{
    Expect CursorChar() == '{'
    normal ds}
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding curly brackets, trimming whitespaces'
    put! = '_{ world }_'
    normal f{
    Expect CursorChar() == '{'
    normal ds{
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding curly brackets (aliased)'
    put! = '_{ world }_'
    normal f{
    Expect CursorChar() == '{'
    normal dsB
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding angle brackets'
    put! = '_< world >_'
    normal f<
    Expect CursorChar() == '<'
    normal ds>
    Expect getline(1) == '_ world _'
  end

  it 'deletes surrounding angle brackets, trimming whitespaces'
    put! = '_< world >_'
    normal f<
    Expect CursorChar() == '<'
    normal ds<
    Expect getline(1) == '_world_'
  end

  it 'deletes surrounding angle brackets (aliased)'
    put! = '_< world >_'
    normal f<
    Expect CursorChar() == '<'
    normal dsa
    Expect getline(1) == '_ world _'
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

end
