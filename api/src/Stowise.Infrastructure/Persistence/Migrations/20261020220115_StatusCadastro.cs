using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class StatusCadastro : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "status_cadastro",
                table: "produtos",
                type: "character varying(30)",
                maxLength: 30,
                nullable: false,
                defaultValue: "Incompleto");

            // Produtos já cadastrados: completos quando todas as embalagens têm peso e as três medidas.
            migrationBuilder.Sql("""
                UPDATE produtos p
                SET status_cadastro = 'Completo'
                WHERE NOT EXISTS (
                    SELECT 1 FROM produto_embalagens e
                    WHERE e.produto_id = p.id
                      AND (e.peso_kg IS NULL OR e.altura_cm IS NULL OR e.largura_cm IS NULL OR e.comprimento_cm IS NULL));
                """);

            migrationBuilder.CreateIndex(
                name: "ix_produtos_status_cadastro_ativo",
                table: "produtos",
                columns: new[] { "status_cadastro", "ativo" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_produtos_status_cadastro_ativo",
                table: "produtos");

            migrationBuilder.DropColumn(
                name: "status_cadastro",
                table: "produtos");
        }
    }
}
