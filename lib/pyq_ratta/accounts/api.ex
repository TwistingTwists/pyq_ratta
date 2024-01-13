defmodule PyqRatta.Accounts do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    resource PyqRatta.Accounts.User
  end
end
