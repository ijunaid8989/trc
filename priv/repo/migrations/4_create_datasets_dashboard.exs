defmodule TRC.Repo.Migrations.CreateDatasetsDashboard do
  use Ecto.Migration

  def up() do
    execute("""
      CREATE
      OR replace view datasets_dashboard AS WITH core AS
      (
        SELECT
          'twitch' AS topic_name,
          tw.id,
          tw.oid,
          tw.channel,
          tw.language,
          tw.mature,
          tw.partnered,
          tw.metadata,
          NULL AS alternate_text,
          NULL AS archived_url,
          NULL AS base_meme_name,
          NULL AS file_size,
          NULL AS md5_hash,
          NULL AS meme_id,
          NULL AS meme_page_url,
          NULL::jsonb AS charge,
          NULL::jsonb AS energy,
          NULL::bigint AS event,
          NULL::numeric AS invariant_mass,
          NULL::bigint AS run,
          NULL::jsonb AS momemtum,
          NULL::jsonb AS phi_angle,
          NULL::jsonb AS pseudorapidity,
          NULL::jsonb AS transverse_momemtum,
          tw.inserted_at,
          tw.updated_at
        FROM
          public.twitch AS tw
        UNION ALL
        SELECT
          'memegen',
          meme.id,
          meme.oid,
          NULL AS channel,
          NULL AS language,
          NULL AS mature,
          NULL AS partnered,
          NULL::jsonb AS metadata,
          meme.alternate_text,
          meme.archived_url,
          meme.base_meme_name,
          meme.file_size,
          meme.md5_hash,
          meme.meme_id,
          meme.meme_page_url,
          NULL::jsonb AS charge,
          NULL::jsonb AS energy,
          NULL::bigint AS event,
          NULL::numeric AS invariant_mass,
          NULL::bigint AS run,
          NULL::jsonb AS momemtum,
          NULL::jsonb AS phi_angle,
          NULL::jsonb AS pseudorapidity,
          NULL::jsonb AS transverse_momemtum,
          meme.inserted_at,
          meme.updated_at
        FROM
          public.memegen AS meme
        UNION ALL
        SELECT
          'collisionelectron',
          collision.id,
          collision.oid,
          NULL AS channel,
          NULL AS language,
          NULL AS mature,
          NULL AS partnered,
          NULL::jsonb AS metadata,
          NULL AS alternate_text,
          NULL AS archived_url,
          NULL AS base_meme_name,
          NULL AS file_size,
          NULL AS md5_hash,
          NULL AS meme_id,
          NULL AS meme_page_url,
          collision.charge,
          collision.energy,
          collision.event,
          collision.invariant_mass,
          collision.run,
          collision.momemtum,
          collision.phi_angle,
          collision.pseudorapidity,
          collision.transverse_momemtum,
          collision.inserted_at,
          collision.updated_at
        FROM
          public.collision_electron AS collision
      )
      SELECT * FROM core;
    """)
  end

  def down() do
    execute("DROP VIEW IF EXISTS datasets_dashboard")
  end
end
