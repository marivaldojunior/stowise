using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RegrasArmazenagem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "classe_abc",
                table: "produtos",
                type: "character varying(30)",
                maxLength: 30,
                nullable: false,
                defaultValue: "C");

            migrationBuilder.CreateTable(
                name: "regras_armazenagem",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    peso = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    ativa = table.Column<bool>(type: "boolean", nullable: false),
                    parametros = table.Column<string>(type: "jsonb", nullable: false),
                    atualizado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    atualizado_por = table.Column<Guid>(type: "uuid", nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_regras_armazenagem", x => x.id);
                });

            migrationBuilder.InsertData(
                table: "regras_armazenagem",
                columns: new[] { "id", "ativa", "atualizado_em", "atualizado_por", "codigo", "parametros", "peso" },
                values: new object[,]
                {
                    { new Guid("0199f0a0-0000-7000-8000-0000000a0001"), true, null, null, "zona", "{}", 0m },
                    { new Guid("0199f0a0-0000-7000-8000-0000000a0002"), true, null, null, "capacidade", "{\"ocupacaoMaxima\":100}", 1m },
                    { new Guid("0199f0a0-0000-7000-8000-0000000a0003"), true, null, null, "curva-abc", "{}", 3m },
                    { new Guid("0199f0a0-0000-7000-8000-0000000a0004"), true, null, null, "fefo", "{\"toleranciaDias\":0}", 2m },
                    { new Guid("0199f0a0-0000-7000-8000-0000000a0005"), true, null, null, "consolidacao", "{\"mesmoLote\":100,\"mesmoProduto\":70,\"vazio\":40,\"outroProduto\":0}", 2m }
                });

            migrationBuilder.CreateIndex(
                name: "ix_regras_armazenagem_codigo",
                table: "regras_armazenagem",
                column: "codigo",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "regras_armazenagem");

            migrationBuilder.DropColumn(
                name: "classe_abc",
                table: "produtos");
        }
    }
}
