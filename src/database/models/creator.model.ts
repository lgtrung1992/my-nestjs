import { UserEntity } from '@/auth/entities/user.entity';
import { Column, Index, JoinColumn, ManyToOne } from 'typeorm';
import { BaseModel } from './base.model';

export abstract class CreatorModel extends BaseModel {
  @Index({ where: '"deleted_at" IS NULL' })
  @Column()
  createdByUserId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'createdByUserId' })
  createdBy: UserEntity;

  @Index({ where: '"deleted_at" IS NULL' })
  @Column()
  updatedByUserId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'updatedByUserId' })
  updatedBy: UserEntity;

  @Index({ where: '"deleted_at" IS NULL' })
  @Column({ nullable: true })
  deletedByUserId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'deletedByUserId' })
  deletedBy: UserEntity;
}
