using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddCatalogo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categorias",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                    parent_id = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_categorias", x => x.id);
                    table.ForeignKey(
                        name: "fk_categorias_categorias_parent_id",
                        column: x => x.parent_id,
                        principalTable: "categorias",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "produtos",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    sku = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    descricao = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    unidade_base = table.Column<string>(type: "character varying(6)", maxLength: 6, nullable: false),
                    classe_armazenagem = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    controla_lote = table.Column<bool>(type: "boolean", nullable: false),
                    controla_validade = table.Column<bool>(type: "boolean", nullable: false),
                    ncm = table.Column<string>(type: "character varying(8)", maxLength: 8, nullable: true),
                    cest = table.Column<string>(type: "character varying(7)", maxLength: 7, nullable: true),
                    categoria_id = table.Column<Guid>(type: "uuid", nullable: true),
                    ativo = table.Column<bool>(type: "boolean", nullable: false),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_produtos", x => x.id);
                    table.ForeignKey(
                        name: "fk_produtos_categorias_categoria_id",
                        column: x => x.categoria_id,
                        principalTable: "categorias",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "produto_embalagens",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    tipo = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    fator_conversao = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    unidade_base = table.Column<bool>(type: "boolean", nullable: false),
                    gtin = table.Column<string>(type: "character varying(14)", maxLength: 14, nullable: true),
                    peso_kg = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true),
                    altura_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true),
                    largura_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true),
                    comprimento_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_produto_embalagens", x => x.id);
                    table.ForeignKey(
                        name: "fk_produto_embalagens_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_categorias_parent_id_nome",
                table: "categorias",
                columns: new[] { "parent_id", "nome" },
                unique: true)
                .Annotation("Npgsql:NullsDistinct", false);

            migrationBuilder.CreateIndex(
                name: "ix_produto_embalagens_gtin",
                table: "produto_embalagens",
                column: "gtin",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_produto_embalagens_produto_id_tipo_fator_conversao",
                table: "produto_embalagens",
                columns: new[] { "produto_id", "tipo", "fator_conversao" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_produtos_categoria_id",
                table: "produtos",
                column: "categoria_id");

            migrationBuilder.CreateIndex(
                name: "ix_produtos_sku",
                table: "produtos",
                column: "sku",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "produto_embalagens");

            migrationBuilder.DropTable(
                name: "produtos");

            migrationBuilder.DropTable(
                name: "categorias");
        }
    }
}
