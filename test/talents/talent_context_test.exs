defmodule Talents.TalentContextTest do
  use Talents.DataCase

  alias Talents.TalentContext

  describe "talents" do
    alias Talents.TalentContext.Talent

    import Talents.TalentContextFixtures

    @invalid_attrs %{}

    test "list_talents/0 returns all talents" do
      talent = talent_fixture()
      assert TalentContext.list_talents() == [talent]
    end

    test "get_talent!/1 returns the talent with given id" do
      talent = talent_fixture()
      assert TalentContext.get_talent!(talent.id) == talent
    end

    test "create_talent/1 with valid data creates a talent" do
      valid_attrs = %{}

      assert {:ok, %Talent{} = talent} = TalentContext.create_talent(valid_attrs)
    end

    test "create_talent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TalentContext.create_talent(@invalid_attrs)
    end

    test "update_talent/2 with valid data updates the talent" do
      talent = talent_fixture()
      update_attrs = %{}

      assert {:ok, %Talent{} = talent} = TalentContext.update_talent(talent, update_attrs)
    end

    test "update_talent/2 with invalid data returns error changeset" do
      talent = talent_fixture()
      assert {:error, %Ecto.Changeset{}} = TalentContext.update_talent(talent, @invalid_attrs)
      assert talent == TalentContext.get_talent!(talent.id)
    end

    test "delete_talent/1 deletes the talent" do
      talent = talent_fixture()
      assert {:ok, %Talent{}} = TalentContext.delete_talent(talent)
      assert_raise Ecto.NoResultsError, fn -> TalentContext.get_talent!(talent.id) end
    end

    test "change_talent/1 returns a talent changeset" do
      talent = talent_fixture()
      assert %Ecto.Changeset{} = TalentContext.change_talent(talent)
    end
  end
end
