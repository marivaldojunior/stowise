using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ImportacaoLinhas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "linhas_com_erro",
                table: "importacoes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "linhas_possivel_duplicata",
                table: "importacoes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "linhas_validas",
                table: "importacoes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "motivo_falha",
                table: "importacoes",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.CreateTable(
                name: "importacao_linhas",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    importacao_id = table.Column<Guid>(type: "uuid", nullable: false),
                    numero_linha = table.Column<int>(type: "integer", nullable: false),
                    dados_brutos = table.Column<string>(type: "jsonb", nullable: false),
                    dados_normalizados = table.Column<string>(type: "jsonb", nullable: false),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    acao = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    produto_correspondente_id = table.Column<Guid>(type: "uuid", nullable: true),
                    similaridade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true),
                    erros = table.Column<string>(type: "jsonb", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_importacao_linhas", x => x.id);
                    table.ForeignKey(
                        name: "fk_importacao_linhas_importacoes_importacao_id",
                        column: x => x.importacao_id,
                        principalTable: "importacoes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_importacao_linhas_produtos_produto_correspondente_id",
                        column: x => x.produto_correspondente_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateIndex(
                name: "ix_importacao_linhas_importacao_id_numero_linha",
                table: "importacao_linhas",
                columns: new[] { "importacao_id", "numero_linha" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_importacao_linhas_importacao_id_status",
                table: "importacao_linhas",
                columns: new[] { "importacao_id", "status" });

            migrationBuilder.CreateIndex(
                name: "ix_importacao_linhas_produto_correspondente_id",
                table: "importacao_linhas",
                column: "produto_correspondente_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "importacao_linhas");

            migrationBuilder.DropColumn(
                name: "linhas_com_erro",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "linhas_possivel_duplicata",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "linhas_validas",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "motivo_falha",
                table: "importacoes");
        }
    }
}
