defmodule PyqRatta.Quiz do
    use Ash.Api,
      extensions: [AshAdmin.Api]
  
    admin do
      show?(true)
    end
  
    resources do
      resource PyqRatta.Quiz.Question
    end
  end
  