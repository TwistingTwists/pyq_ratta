defmodule PyqRatta.Databank do
  # require Ash.CodeInterface

  use Ash.Api, extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    resource PyqRatta.Databank.Question
    resource PyqRatta.Databank.Quiz
    resource PyqRatta.Databank.QuizQuestion
    # resource PyqRatta.QuizPractice.Response
  end

  # https://elixirforum.com/t/code-interface-for-api/60602
  # Ash.CodeInterface.define_interface(__MODULE__, Resource1)
  # Ash.CodeInterface.define_interface(__MODULE__, Resource2)
  # Ash.CodeInterface.define_interface(__MODULE__, Resource3)
end
