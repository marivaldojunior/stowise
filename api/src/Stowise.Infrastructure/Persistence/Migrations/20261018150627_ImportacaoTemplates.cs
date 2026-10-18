using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ImportacaoTemplates : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "fingerprint",
                table: "importacoes",
                type: "character(64)",
                fixedLength: true,
                maxLength: 64,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "mapeamento",
                table: "importacoes",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "mapeamento_confirmado_em",
                table: "importacoes",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "mapeamento_confirmado_por",
                table: "importacoes",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "template_id",
                table: "importacoes",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "importacoes",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.CreateTable(
                name: "importacao_templates",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    tipo = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    nome = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fingerprint = table.Column<string>(type: "character(64)", fixedLength: true, maxLength: 64, nullable: false),
                    formato = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    encoding = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true),
                    delimitador = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: true),
                    separador_decimal = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    mapeamento = table.Column<string>(type: "jsonb", nullable: false),
                    sugerido_por_ia = table.Column<bool>(type: "boolean", nullable: false),
                    confirmado_por = table.Column<Guid>(type: "uuid", nullable: false),
                    confirmado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    vezes_usado = table.Column<int>(type: "integer", nullable: false),
                    ultimo_uso_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_importacao_templates", x => x.id);
                    table.ForeignKey(
                        name: "fk_importacao_templates_usuarios_confirmado_por",
                        column: x => x.confirmado_por,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_importacoes_mapeamento_confirmado_por",
                table: "importacoes",
                column: "mapeamento_confirmado_por");

            migrationBuilder.CreateIndex(
                name: "ix_importacoes_template_id",
                table: "importacoes",
                column: "template_id");

            migrationBuilder.CreateIndex(
                name: "ix_importacao_templates_confirmado_por",
                table: "importacao_templates",
                column: "confirmado_por");

            migrationBuilder.CreateIndex(
                name: "ix_importacao_templates_tipo_fingerprint",
                table: "importacao_templates",
                columns: new[] { "tipo", "fingerprint" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "fk_importacoes_templates_importacao_template_id",
                table: "importacoes",
                column: "template_id",
                principalTable: "importacao_templates",
                principalColumn: "id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "fk_importacoes_usuarios_mapeamento_confirmado_por",
                table: "importacoes",
                column: "mapeamento_confirmado_por",
                principalTable: "usuarios",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_importacoes_templates_importacao_template_id",
                table: "importacoes");

            migrationBuilder.DropForeignKey(
                name: "fk_importacoes_usuarios_mapeamento_confirmado_por",
                table: "importacoes");

            migrationBuilder.DropTable(
                name: "importacao_templates");

            migrationBuilder.DropIndex(
                name: "ix_importacoes_mapeamento_confirmado_por",
                table: "importacoes");

            migrationBuilder.DropIndex(
                name: "ix_importacoes_template_id",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "fingerprint",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "mapeamento",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "mapeamento_confirmado_em",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "mapeamento_confirmado_por",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "template_id",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "importacoes");
        }
    }
}
