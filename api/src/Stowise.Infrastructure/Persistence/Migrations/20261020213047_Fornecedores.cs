using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Fornecedores : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "fornecedores",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    cnpj = table.Column<string>(type: "character varying(14)", maxLength: 14, nullable: false),
                    razao_social = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    nome_fantasia = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_fornecedores", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "produto_fornecedores",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    fornecedor_id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo_fornecedor = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    embalagem_id = table.Column<Guid>(type: "uuid", nullable: false),
                    unidade_fornecedor = table.Column<string>(type: "character varying(6)", maxLength: 6, nullable: false),
                    fator_conversao = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    confirmado_por = table.Column<Guid>(type: "uuid", nullable: false),
                    confirmado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_produto_fornecedores", x => x.id);
                    table.ForeignKey(
                        name: "fk_produto_fornecedores_fornecedores_fornecedor_id",
                        column: x => x.fornecedor_id,
                        principalTable: "fornecedores",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_produto_fornecedores_produto_embalagens_embalagem_id",
                        column: x => x.embalagem_id,
                        principalTable: "produto_embalagens",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_produto_fornecedores_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_fornecedores_cnpj",
                table: "fornecedores",
                column: "cnpj",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_produto_fornecedores_embalagem_id",
                table: "produto_fornecedores",
                column: "embalagem_id");

            migrationBuilder.CreateIndex(
                name: "ix_produto_fornecedores_fornecedor_id_codigo_fornecedor",
                table: "produto_fornecedores",
                columns: new[] { "fornecedor_id", "codigo_fornecedor" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_produto_fornecedores_produto_id",
                table: "produto_fornecedores",
                column: "produto_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "produto_fornecedores");

            migrationBuilder.DropTable(
                name: "fornecedores");
        }
    }
}
