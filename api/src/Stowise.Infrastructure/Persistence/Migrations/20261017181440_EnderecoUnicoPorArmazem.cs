using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class EnderecoUnicoPorArmazem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_enderecos_zona_id_codigo",
                table: "enderecos");

            // Coluna nova em tabela com dados: cria aceitando nulo, preenche pelo armazém da zona e só então exige valor.
            migrationBuilder.AddColumn<Guid>(
                name: "armazem_id",
                table: "enderecos",
                type: "uuid",
                nullable: true);

            migrationBuilder.Sql(
                """
                UPDATE enderecos AS e
                SET armazem_id = z.armazem_id
                FROM zonas AS z
                WHERE z.id = e.zona_id;
                """);

            migrationBuilder.AlterColumn<Guid>(
                name: "armazem_id",
                table: "enderecos",
                type: "uuid",
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "ix_enderecos_armazem_id_codigo",
                table: "enderecos",
                columns: new[] { "armazem_id", "codigo" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_enderecos_zona_id",
                table: "enderecos",
                column: "zona_id");

            migrationBuilder.AddForeignKey(
                name: "fk_enderecos_armazens_armazem_id",
                table: "enderecos",
                column: "armazem_id",
                principalTable: "armazens",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_enderecos_armazens_armazem_id",
                table: "enderecos");

            migrationBuilder.DropIndex(
                name: "ix_enderecos_armazem_id_codigo",
                table: "enderecos");

            migrationBuilder.DropIndex(
                name: "ix_enderecos_zona_id",
                table: "enderecos");

            migrationBuilder.DropColumn(
                name: "armazem_id",
                table: "enderecos");

            migrationBuilder.CreateIndex(
                name: "ix_enderecos_zona_id_codigo",
                table: "enderecos",
                columns: new[] { "zona_id", "codigo" },
                unique: true);
        }
    }
}
