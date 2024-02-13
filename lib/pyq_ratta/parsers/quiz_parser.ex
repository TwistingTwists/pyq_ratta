defmodule PyqRatta.QuizParser do
  import NimbleParsec
  require Pegasus

  @question_opts [
    question: [tag: :question],
    question_number: [tag: :question_number],
    topic: [collect: true, tag: :topic],
    question_text: [tag: :question_text, collect: true] ,
    choices: [tag: :choices] ,
    ABCD: [tag: :choice_option, collect: true] ,
    choices_texts: [tag: :choices_texts, collect: true] ,
  ]

  Pegasus.parser_from_string(
  """
  question <- header

  header          <- "Q" question_number dot (whitespace*)  topic  question_text choices

  topic           <-  (curly text_ws+ curly)
  curly           <-   "{" / "}"


  question_text   <- (!"a)" q_rich_text)+
  q_rich_text     <- symbols? whitespace? text symbols? whitespace?

  question_number <- integer+

  choices         <- whitespace? ( ABCD choices_texts)+
  choices_texts   <- (whitespace? (!ABCD rich_text)+ whitespace?)+

  rich_text       <- (limited_symbols? text limited_symbols?)
  limited_symbols <- (dot / ":" / "/")

  text_ws         <- (text whitespace?) / (whitespace? text)
  text            <-  [-0-9a-zA-Z\_,]+

  ABCD            <- "a)" / "b)" / "c)" / "d)"

  whitespace      <- [ \t\n\r]+
  integer         <- [0-9]
  symbols         <-   ":"  / dot / "(" / ")" / "/" / curly / "?"
  dot             <- "."
  EndOfLine       <- '\r\n' / '\n' / '\r'
  EndOfFile       <- !.


 """,
   @question_opts)

  # defcombinatorp(:special_minus,utf8_char([?–]))


  defparsec :parse_question, parsec(:question)

end
