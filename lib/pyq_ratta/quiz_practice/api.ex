defmodule PyqRatta.QuizPractice do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    resource PyqRatta.QuizPractice.Response
    resource PyqRatta.QuizPractice.UserAttempt
  end

  # https://elixirforum.com/t/ash-query-composition-appreciation-post/58815/10
end
