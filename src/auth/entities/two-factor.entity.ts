import { BaseModel } from '@/database/models/base.model';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { UserEntity } from './user.entity';

// https://www.better-auth.com/docs/concepts/database#core-schema
@Entity('two_factors')
export class TwoFactorEntity extends BaseModel {
  @Column({ name: 'user_id' })
  userId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column({ nullable: true })
  secret: string;

  @Column({ nullable: true, name: 'backup_codes' })
  backupCodes: string;
}
