using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ImportacaoEfetivacao : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "produtos_atualizados",
                table: "importacoes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "produtos_criados",
                table: "importacoes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "efetivada_em",
                table: "importacao_linhas",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "produtos_atualizados",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "produtos_criados",
                table: "importacoes");

            migrationBuilder.DropColumn(
                name: "efetivada_em",
                table: "importacao_linhas");
        }
    }
}
