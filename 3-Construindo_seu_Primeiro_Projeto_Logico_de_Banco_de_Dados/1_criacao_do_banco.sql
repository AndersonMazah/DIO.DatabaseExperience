CREATE DATABASE ECOMMERCE;

USE ECOMMERCE;

CREATE TABLE Cliente (
	id INT NOT NULL IDENTITY(1, 1),
	Nome VARCHAR(100) NOT NULL,
	Documento VARCHAR(18),
	TipoPessoa  varchar (2) NOT NULL CHECK (TipoPessoa IN('PF', 'PJ')) DEFAULT 'PF',
	CONSTRAINT unique_Cliente_Documento UNIQUE (Documento),
	CONSTRAINT pk_Cliente_id PRIMARY KEY (id)
);

CREATE TABLE StatusPedido (
	id INT NOT NULL IDENTITY(1, 1),
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_StatusPedido_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_StatusPedido_id PRIMARY KEY (id)
);

CREATE TABLE TipoPagamento (
	id INT NOT NULL IDENTITY(1, 1),
	Identificacao VARCHAR(50) NOT NULL,
	CONSTRAINT unique_TipoPagamento_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_TipoPagamento_id PRIMARY KEY (id)
);

CREATE TABLE StatusEntrega (
	id INT NOT NULL IDENTITY(1, 1),
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_StatusEntrega_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_StatusEntrega_id PRIMARY KEY (id)
);

CREATE TABLE EnderecoEntrega (
	id INT NOT NULL IDENTITY(1, 1),
	IDStatusEntrega INT NOT NULL,
	CodRastreio VARCHAR(50) NOT NULL,
	CEP VARCHAR(8) NOT NULL,
	Logradouro VARCHAR(150) NOT NULL,
	Numero VARCHAR(10) NOT NULL,
	Complemento VARCHAR(10),
	DataEntrega DATETIME,
	CONSTRAINT pk_EnderecoEntrega_id PRIMARY KEY (id),
	CONSTRAINT fk_EnderecoEntrega_idStatusEntrega_StatusEntrega_id FOREIGN KEY (IDStatusEntrega) REFERENCES StatusEntrega(id) ON DELETE NO ACTION
);

CREATE TABLE Estoque (
	id INT NOT NULL IDENTITY(1, 1),
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Estoque_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_Estoque_id PRIMARY KEY (id)
);

CREATE TABLE VendedorTerceiro (
	id INT NOT NULL IDENTITY(1, 1),
	RazaoSocial VARCHAR(100) NOT NULL,
	CNPJ VARCHAR(45) NOT NULL,
	CONSTRAINT unique_VendedorTerceiro_CNPJ UNIQUE (CNPJ),
	CONSTRAINT pk_VendedorTerceiro_id PRIMARY KEY (id)
);

CREATE TABLE Fornecedor (
	id INT NOT NULL IDENTITY(1, 1),
	RazaoSocial VARCHAR(100) NOT NULL,
	CNPJ VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Fornecedor_CNPJ UNIQUE (CNPJ),
	CONSTRAINT pk_Fornecedor_id PRIMARY KEY (id)
);

CREATE TABLE Categoria (
	id INT NOT NULL IDENTITY(1, 1),
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Categoria_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_Categoria_id PRIMARY KEY (id)
);

CREATE TABLE Produto (
	id INT NOT NULL IDENTITY(1, 1),
	idCategoria INT NOT NULL,
	Identificacao VARCHAR(100) NOT NULL,
	Descricao TEXT NOT NULL,
	Valor DECIMAL(18,2) NOT NULL,
	CONSTRAINT unique_Produto_Identificacao UNIQUE (Identificacao),
	CONSTRAINT pk_Produto_id PRIMARY KEY (id),
	CONSTRAINT fk_Produto_idCategoria_Categoria_id FOREIGN KEY (idCategoria) REFERENCES Categoria(id) ON DELETE NO ACTION
);

CREATE TABLE ProdutoFornecedor (
	id INT NOT NULL IDENTITY(1, 1),
	idProduto INT NOT NULL,
	idFornecedor INT NOT NULL,
	CONSTRAINT pk_ProdutoFornecedor_id PRIMARY KEY (id),
	CONSTRAINT fk_ProdutoFornecedor_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION,
	CONSTRAINT fk_ProdutoFornecedor_idFornecedor_Fornecedor_id FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(id) ON DELETE NO ACTION
);

CREATE TABLE ProdutoVendedorTerceiro (
	id INT NOT NULL IDENTITY(1, 1),
	idProduto INT NOT NULL,
	idVendedorTerceiro INT NOT NULL,
	CONSTRAINT pk_ProdutoVendedorTerceiro_id PRIMARY KEY (id),
	CONSTRAINT fk_ProdutoVendedorTerceiro_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION,
	CONSTRAINT fk_ProdutoVendedorTerceiro_idVendedorTerceiro_VendedorTerceiro_id FOREIGN KEY (idVendedorTerceiro) REFERENCES VendedorTerceiro(id) ON DELETE NO ACTION
);

CREATE TABLE ProdutoEstoque (
	id INT NOT NULL IDENTITY(1, 1),
	idProduto INT NOT NULL,
	idEstoque INT NOT NULL,
	Quantidade INT NOT NULL,
	CONSTRAINT pk_ProdutoEstoque_id PRIMARY KEY (id),
	CONSTRAINT fk_ProdutoEstoque_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION,
	CONSTRAINT fk_ProdutoEstoque_idEstoque_Estoque_id FOREIGN KEY (idEstoque) REFERENCES Estoque(id) ON DELETE NO ACTION
);

CREATE TABLE Pedido (
	id INT NOT NULL IDENTITY(1, 1),
	idEnderecoEntrega INT NOT NULL,
	idCliente INT NOT NULL,
	idStatusPedido INT NOT NULL,
	Codigo VARCHAR(45) NOT NULL,
	DataPedido DATETIME NOT NULL,
	VlrFrete DECIMAL(18,2),
	VlrPedido DECIMAL(18,2),
	VlrTotal DECIMAL(18,2),
	CONSTRAINT unique_Pedido_Codigo UNIQUE (Codigo),
	CONSTRAINT pk_Pedido_id PRIMARY KEY (id),
	CONSTRAINT fk_Pedido_idEnderecoEntrega_EnderecoEntrega_id FOREIGN KEY (idEnderecoEntrega) REFERENCES EnderecoEntrega(id) ON DELETE NO ACTION,
	CONSTRAINT fk_Pedido_idCliente_Cliente_id FOREIGN KEY (idCliente) REFERENCES Cliente(id) ON DELETE NO ACTION,
	CONSTRAINT fk_Pedido_idStatusPedido_StatusPedido_id FOREIGN KEY (idStatusPedido) REFERENCES StatusPedido(id) ON DELETE NO ACTION
);

CREATE TABLE PedidoProduto (
	id INT NOT NULL IDENTITY(1, 1),
	idPedido INT NOT NULL,
	idProduto INT NOT NULL,
	CONSTRAINT pk_PedidoProduto_id PRIMARY KEY (id),
	CONSTRAINT fk_PedidoProduto_idPedido_Pedido_id FOREIGN KEY (idPedido) REFERENCES Pedido(id) ON DELETE NO ACTION,
	CONSTRAINT fk_PedidoProduto_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION
);

CREATE TABLE TipoPagamentoPedido (
	id INT NOT NULL IDENTITY(1, 1),
	idPedido INT NOT NULL,
	idTipoPagamento INT NOT NULL,
	Valor DECIMAL(18,2),
	CONSTRAINT pk_TipoPagamentoPedido_id PRIMARY KEY (id),
	CONSTRAINT fk_TipoPagamentoPedido_idPedido_Pedido_id FOREIGN KEY (idPedido) REFERENCES Pedido(id) ON DELETE NO ACTION,
	CONSTRAINT fk_TipoPagamentoPedido_idTipoPagamento_TipoPagamento_id FOREIGN KEY (idTipoPagamento) REFERENCES TipoPagamento(id) ON DELETE NO ACTION
);