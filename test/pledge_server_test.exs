defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "Only caches 3 most recent pledges" do
    pid = PledgeServer.start()

    PledgeServer.create_pledge("John", 100)
    PledgeServer.create_pledge("Tim", 500)
    PledgeServer.create_pledge("Yolanda", 200)
    PledgeServer.create_pledge("Peter", 300)
    PledgeServer.create_pledge("Michael", 20)
    PledgeServer.create_pledge("Will", 50)

    assert length(PledgeServer.recent_pledges()) == 3
    assert PledgeServer.recent_pledges() == [
      {"Will", 50},
      {"Michael", 20},
      {"Peter", 300}
    ]
  end

  test "calculates total correctly" do
    pid = PledgeServer.start()

    PledgeServer.create_pledge("John", 100)
    PledgeServer.create_pledge("Tim", 500)
    PledgeServer.create_pledge("Yolanda", 200)
    PledgeServer.create_pledge("Peter", 300)
    PledgeServer.create_pledge("Michael", 20)
    PledgeServer.create_pledge("Will", 50)

    assert PledgeServer.total_pledged() == 370
  end

end
