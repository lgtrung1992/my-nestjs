import { MigrationInterface, QueryRunner } from 'typeorm';

export class Init1746266963361 implements MigrationInterface {
  name = 'Init1746266963361';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            CREATE TABLE "verifications" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "identifier" character varying NOT NULL,
                "value" character varying NOT NULL,
                "expires_at" TIMESTAMP NOT NULL,
                CONSTRAINT "PK_f7e3a90ca384e71d6e2e93bb340" PRIMARY KEY ("id")
            )
        `);
    await queryRunner.query(`
            CREATE TYPE "public"."user_role_enum" AS ENUM('professor', 'staff', 'admin', 'superadmin')
        `);
    await queryRunner.query(`
            CREATE TABLE "users" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "username" character varying NOT NULL,
                "email" character varying NOT NULL,
                "is_email_verified" boolean NOT NULL DEFAULT false,
                "role" "public"."user_role_enum" NOT NULL DEFAULT 'professor',
                "image" character varying,
                "bio" character varying,
                "first_name" character varying,
                "last_name" character varying,
                "university_id" character varying,
                "status" character varying DEFAULT 'pending',
                "last_login_at" TIMESTAMP,
                "phone" character varying,
                "address" character varying,
                "department" character varying,
                "position" character varying,
                "research_field" character varying,
                CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY ("id")
            )
        `);
    await queryRunner.query(`
            CREATE UNIQUE INDEX "IDX_070157ac5f9096d1a00bab15aa" ON "users" ("username")
            WHERE "deleted_at" IS NULL
        `);
    await queryRunner.query(`
            CREATE UNIQUE INDEX "IDX_d0012b9482ca5b4f270e6fdb5e" ON "users" ("email")
            WHERE "deleted_at" IS NULL
        `);
    await queryRunner.query(`
            CREATE TABLE "sessions" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "user_id" uuid NOT NULL,
                "token" character varying NOT NULL,
                "expires_at" TIMESTAMP NOT NULL,
                "ip_address" character varying,
                "user_agent" character varying,
                CONSTRAINT "PK_f55da76ac1c3ac420f444d2ff11" PRIMARY KEY ("id")
            )
        `);
    await queryRunner.query(`
            CREATE TABLE "accounts" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "user_id" uuid NOT NULL,
                "account_id" character varying NOT NULL,
                "provider_id" character varying NOT NULL,
                "access_token" character varying,
                "refresh_token" character varying,
                "access_token_expires_at" TIMESTAMP,
                "refresh_token_expires_at" TIMESTAMP,
                "scope" character varying,
                "id_token" character varying,
                "password" character varying,
                CONSTRAINT "PK_54115ee388cdb6d86bb4bf5b2ea" PRIMARY KEY ("id")
            )
        `);
    await queryRunner.query(`
            ALTER TABLE "sessions"
            ADD CONSTRAINT "FK_3d2f174ef04fb312fdebd0ddc53" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE "accounts"
            ADD CONSTRAINT "FK_60328bf27019ff5498c4b977421" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE "accounts" DROP CONSTRAINT "FK_60328bf27019ff5498c4b977421"
        `);
    await queryRunner.query(`
            ALTER TABLE "sessions" DROP CONSTRAINT "FK_3d2f174ef04fb312fdebd0ddc53"
        `);
    await queryRunner.query(`
            DROP TABLE "accounts"
        `);
    await queryRunner.query(`
            DROP TABLE "sessions"
        `);
    await queryRunner.query(`
            DROP INDEX "public"."IDX_d0012b9482ca5b4f270e6fdb5e"
        `);
    await queryRunner.query(`
            DROP INDEX "public"."IDX_070157ac5f9096d1a00bab15aa"
        `);
    await queryRunner.query(`
            DROP TABLE "users"
        `);
    await queryRunner.query(`
            DROP TYPE "public"."user_role_enum"
        `);
    await queryRunner.query(`
            DROP TABLE "verifications"
        `);
  }
}
