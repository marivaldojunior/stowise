using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ImportacaoSugestaoIa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "mapeamento_sugerido_por_ia",
                table: "importacoes",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "motivo_sem_sugestao",
                table: "importacoes",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "regras",
                table: "importacoes",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "sugestao_ia",
                table: "importacoes",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "regras",
                table: "importacao_templates",
                type: "jsonb",
                nullable: false,
                defaultValue: "{\"separadorDecimal\":null,\"unidades\":[],\"valoresVerdadeiros\":[],\"valoresFalsos\":[]}");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "mapeamento_sugerido_por_ia",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "motivo_sem_sugestao",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "regras",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "sugestao_ia",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "regras",
                table: "importacao_templates");
        }
    }
}
