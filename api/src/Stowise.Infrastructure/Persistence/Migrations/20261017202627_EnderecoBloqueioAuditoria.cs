using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class EnderecoBloqueioAuditoria : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "bloqueado_em",
                table: "enderecos",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "bloqueado_por",
                table: "enderecos",
                type: "uuid",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "bloqueado_em",
                table: "enderecos");

            migrationBuilder.DropColumn(
                name: "bloqueado_por",
                table: "enderecos");
        }
    }
}
