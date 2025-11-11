defmodule Talents.Repo.Migrations.AlterTalentsFields do
  use Ecto.Migration

  def change do
    alter table(:talents) do
      add :i_am, :text
      add :i_will, :text
      add :i_love, :text
      add :i_dislike, :text
      add :i_bring, :text
      add :i_need, :text
      add :metaphor_image, :text
      add :barrier_label, :text
      add :text_contrast_one, :text
      add :text_contrast_two, :text
      remove :contrast_id
    end
  end
end
