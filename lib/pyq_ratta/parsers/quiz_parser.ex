defmodule PyqRatta.QuizParser do
  import NimbleParsec
  require Pegasus

  @question_opts [
    question: [tag: :question],
    question_number: [tag: :question_number],
    question_header: [tag: :question_header, collect: true] ,
    topic: [collect: true, tag: :topic],
    # special_minus: [ignore: true]
    rest_question: [tag: :rest_question, collect: true] ,
    choices: [tag: :choices] ,
    ABCD: [tag: :choice_option, collect: true] ,
    choices_texts: [tag: :choices_texts, collect: true] ,



  ]

  Pegasus.parser_from_string(
  """
  question <- header

  header          <- "Q" question_number dot (space*)  topic  question_header rest_question choices

  topic           <-  (curly text_ws+ curly)
  curly           <-   "{" / "}"

  question_header <- ((text_ws+  symbols) / text+)  EndOfLine+
  question_number <- integer+

  rest_question   <- (!"?" extended_text )+


  choices   <- . space+ ( ABCD choices_texts)+
  choices_texts <- text_or_ws+ whitespace*

  text_or_ws <- whitespace* (!ABCD text)

  text_ws   <- text whitespace* / whitespace* text

  text    <-  [-0-9a-zA-Z\_]+

  ABCD      <- "a)" / "b)" / "c)" / "d)"
  whitespace <- [ \t\n\r]+


  integer         <- ([0-9])

  extended_text   <- ( curly text_ws curly ) / ( symbols text_ws symbols ) / text_ws  / (symbols text_ws)

  symbols         <-   ":"  / dot / "(" / ")" / "/"

  dot             <- "."
  space           <- ' ' / '\t' / EndOfLine
  EndOfLine       <- '\r\n' / '\n' / '\r'
  EndOfFile       <- !.


 """,
   @question_opts)

  # defcombinatorp(:special_minus,utf8_char([?–]))


  defparsec :parse_question, parsec(:question)

end
