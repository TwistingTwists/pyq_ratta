defmodule PyqRatta.Extensions.AddTimestamps do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def transform(dsl_state) do
    {:ok, inserted_at} =
      Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :create_timestamp,
        name: :inserted_at
      )

    {:ok, updated_at} =
      Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :update_timestamp,
        name: :updated_at
      )

    {:ok,
     dsl_state
     |> Transformer.add_entity([:attributes], inserted_at)
     |> Transformer.add_entity([:attributes], updated_at)}
  end
end
