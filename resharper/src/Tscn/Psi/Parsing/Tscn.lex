using System;
using JetBrains.ReSharper.Plugins.Godot.Tscn.Psi.Parsing.TokenNodeTypes;
using JetBrains.ReSharper.Psi.Parsing;
using JetBrains.Text;
using JetBrains.Util;

%%

%unicode

%init{
  myCurrentTokenType = null;
%init}

%namespace JetBrains.ReSharper.Plugins.Godot.Tscn.Psi.Parsing
%class TscnLexerGenerated
%implements IIncrementalLexer
%function _locateToken
%virtual
%public
%type TokenNodeType
%ignorecase

%eofval{
  myCurrentTokenType = null; return myCurrentTokenType;
%eofval}

%include Chars.lex

%{ /* Based on code-defined lexing from Godot's VariantParser::get_token() */
%}

CARRIAGE_RETURN_CHAR=\u000D
LINE_FEED_CHAR=\u000A
NEW_LINE_PAIR=({CARRIAGE_RETURN_CHAR}?{LINE_FEED_CHAR}|{CARRIAGE_RETURN_CHAR}|(\u0085)|(\u2028)|(\u2029))
NOT_NEW_LINE=([^\u0085\u2028\u2029\u000D\u000A])

INPUT_CHARACTER={NOT_NEW_LINE}

COMMENT=(";"{INPUT_CHARACTER}*)

SIMPLE_ESCAPE_SEQUENCE=(\\{NOT_NEW_LINE})
HEXADECIMAL_ESCAPE_SEQUENCE=(\\x{HEX_DIGIT}({HEX_DIGIT}|{HEX_DIGIT}{HEX_DIGIT}|{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT})?)
UNICODE_ESCAPE_SEQUENCE=((\\u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT})|(\\U{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}))

WHITE_SPACE_CHAR=({UNICODE_ZS}|(\u0009)|(\u000B)|(\u000C)|(\u200B)|(\uFEFF))
WHITE_SPACE=({WHITE_SPACE_CHAR}+)

DECIMAL_DIGIT=[0-9]
HEX_DIGIT=({DECIMAL_DIGIT}|[A-Fa-f])

NUMERIC_LITERAL_SEPARATOR="_"

DECIMAL_DIGITS=({DECIMAL_DIGIT}+({NUMERIC_LITERAL_SEPARATOR}{DECIMAL_DIGIT}+)*)
HEXADECIMAL_DIGITS=({HEX_DIGIT}+({NUMERIC_LITERAL_SEPARATOR}{HEX_DIGIT}+)*)

DECIMAL_INTEGER_LITERAL=({DECIMAL_DIGITS})
HEXADECIMAL_INTEGER_LITERAL=(0[Xx]({HEXADECIMAL_DIGITS}))
INTEGER_LITERAL=({DECIMAL_INTEGER_LITERAL}|{HEXADECIMAL_INTEGER_LITERAL})

EXPONENT_PART=([eE]([+-])?{DECIMAL_DIGITS})
REAL_LITERAL=(((({DECIMAL_DIGITS})?"."{DECIMAL_DIGITS})|({DECIMAL_DIGITS}"."({DECIMAL_DIGITS})?))({EXPONENT_PART})?)|({DECIMAL_DIGITS}{EXPONENT_PART})

NUMERIC_LITERAL=({INTEGER_LITERAL}|{REAL_LITERAL})

COLOR_LITERAL=(#{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT})

STRING_LITERAL_CHARACTER_INNER=[^\"\\]

STRING_LITERAL_CHARACTER=({STRING_LITERAL_CHARACTER_INNER}|{HEXADECIMAL_ESCAPE_SEQUENCE}|{UNICODE_ESCAPE_SEQUENCE}|{SIMPLE_ESCAPE_SEQUENCE})

STRING_NAME_LITERAL=(@\"{STRING_LITERAL_CHARACTER}*\")
STRING_LITERAL=(\"{STRING_LITERAL_CHARACTER}*\")

LETTER_CHARACTER=({UNICODE_LL}|{UNICODE_LM}|{UNICODE_LO}|{UNICODE_LT}|{UNICODE_LU}|{UNICODE_NL}|{UNICODE_ESCAPE_SEQUENCE})
DECIMAL_DIGIT_CHARACTER={UNICODE_ND}
CONNECTING_CHARACTER={UNICODE_PC}
COMBINING_CHARACTER=({UNICODE_MC}|{UNICODE_MN})

IDENTIFIER_START_CHARACTER=({LETTER_CHARACTER}|(_))
IDENTIFIER_PART_CHARACTER=({LETTER_CHARACTER}|{DECIMAL_DIGIT_CHARACTER}|{CONNECTING_CHARACTER}|{COMBINING_CHARACTER}|([_/]))
IDENTIFIER=({IDENTIFIER_START_CHARACTER}({IDENTIFIER_PART_CHARACTER}*))

%%
<YYINITIAL> {WHITE_SPACE}  { return TscnTokenNodeTypes.WHITE_SPACE; }
<YYINITIAL> {NEW_LINE_PAIR}  { return TscnTokenNodeTypes.NEW_LINE; }
<YYINITIAL> "{"  { return TscnTokenNodeTypes.LBRACE; }
<YYINITIAL> "}" { return TscnTokenNodeTypes.RBRACE; }
<YYINITIAL> "["  { return TscnTokenNodeTypes.LBRACKET; }
<YYINITIAL> "]"  { return TscnTokenNodeTypes.RBRACKET; }
<YYINITIAL> "("  { return TscnTokenNodeTypes.LPAREN; }
<YYINITIAL> ")"  { return TscnTokenNodeTypes.RPAREN; }
<YYINITIAL> "," { return TscnTokenNodeTypes.COMMA; }
<YYINITIAL> ":"  { return TscnTokenNodeTypes.COLON; }
<YYINITIAL> "." { return TscnTokenNodeTypes.PERIOD; }
<YYINITIAL> "=" { return TscnTokenNodeTypes.EQUALS; }

<YYINITIAL> {COMMENT}  { return TscnTokenNodeTypes.COMMENT; }
<YYINITIAL> {NUMERIC_LITERAL}  { return TscnTokenNodeTypes.NUMERIC_LITERAL; }
<YYINITIAL> {IDENTIFIER}  { return FindKeywordByCurrentToken() ?? TscnTokenNodeTypes.IDENTIFIER; }
<YYINITIAL> {STRING_NAME_LITERAL}  { return TscnTokenNodeTypes.STRING_NAME_LITERAL; }
<YYINITIAL> {STRING_LITERAL}  { return TscnTokenNodeTypes.STRING_LITERAL; }
<YYINITIAL> {COLOR_LITERAL}  { return TscnTokenNodeTypes.COLOR_LITERAL; }

<YYINITIAL> . { return TscnTokenNodeTypes.EOF; }