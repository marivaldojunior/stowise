using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ConferenciaRecebimento : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "conferido_em",
                table: "recebimentos",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "conferido_por",
                table: "recebimentos",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "conferido_em",
                table: "recebimento_itens",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "conferido_por",
                table: "recebimento_itens",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "divergente",
                table: "recebimento_itens",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "lotes_conferidos",
                table: "recebimento_itens",
                type: "jsonb",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<decimal>(
                name: "quantidade_conferida",
                table: "recebimento_itens",
                type: "numeric(18,4)",
                precision: 18,
                scale: 4,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "conferido_em",
                table: "recebimentos");

            migrationBuilder.DropColumn(
                name: "conferido_por",
                table: "recebimentos");

            migrationBuilder.DropColumn(
                name: "conferido_em",
                table: "recebimento_itens");

            migrationBuilder.DropColumn(
                name: "conferido_por",
                table: "recebimento_itens");

            migrationBuilder.DropColumn(
                name: "divergente",
                table: "recebimento_itens");

            migrationBuilder.DropColumn(
                name: "lotes_conferidos",
                table: "recebimento_itens");

            migrationBuilder.DropColumn(
                name: "quantidade_conferida",
                table: "recebimento_itens");
        }
    }
}
