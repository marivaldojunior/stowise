using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class IdempotenciaEConcorrencia : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "saldos",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.AddColumn<Guid>(
                name: "idempotency_key",
                table: "movimentacoes",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "enderecos",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_idempotency_key",
                table: "movimentacoes",
                column: "idempotency_key",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_movimentacoes_idempotency_key",
                table: "movimentacoes");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "saldos");

            migrationBuilder.DropColumn(
                name: "idempotency_key",
                table: "movimentacoes");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "enderecos");
        }
    }
}
